# -*- coding: utf-8 -*-
'''
Runner Module for Interacting with Zenoss

:configuration: This module can be used by specifying the name of a
    configuration profile in the master config.

    For example:

    .. code-block:: yaml

        zenoss:
            hostname: https://zenoss.example.com
            username: admin
            password: admin123
'''
from __future__ import absolute_import

# Import python libs
import json
import logging
import re

# Import salt libs

try:
    import requests
    HAS_LIBS = True
except ImportError:
    HAS_LIBS = False

log = logging.getLogger(__name__)

ROUTERS = {'MessagingRouter': 'messaging',
           'EventsRouter': 'evconsole',
           'ProcessRouter': 'process',
           'ServiceRouter': 'service',
           'DeviceRouter': 'device',
           'NetworkRouter': 'network',
           'TemplateRouter': 'template',
           'DetailNavRouter': 'detailnav',
           'ReportRouter': 'report',
           'MibRouter': 'mib',
           'ZenPackRouter': 'zenpack'}

PROD_STATES = {'Production': 1000,
               'Pre-Production': 500,
               'Test': 400,
               'Maintenance': 300,
               'Decommissioned': -1}


def __virtual__():
    '''
    Only load if requests is installed
    '''
    if HAS_LIBS:
        return 'zenoss'


def _session():
    '''
    Create a session to be used when connecting to Zenoss.
    '''

    config = __opts__.get('zenoss', None)
    session = requests.session()
    session.auth = (config.get('username'), config.get('password'))
    session.verify = False
    session.headers.update({'Content-type': 'application/json; charset=utf-8'})
    return session


def _router_request(router, method, data=None):
    '''
    Make a request to the Zenoss API router
    '''
    if router not in ROUTERS:
        return False

    req_data = json.dumps([dict(
        action=router,
        method=method,
        data=data,
        type='rpc',
        tid=1)])

    config = __opts__.get('zenoss', None)
    log.debug('Making request to router %s with method %s', router, method)
    url = '{0}/zport/dmd/{1}_router'.format(config.get('hostname'), ROUTERS[router])
    response = _session().post(url, data=req_data)

    # The API returns a 200 response code even whe auth is bad.
    # With bad auth, the login page is displayed. Here I search for
    # an element on the login form to determine if auth failed.
    if re.search('name="__ac_name"', response.content):
        log.error('Request failed. Bad username/password.')
        raise Exception('Request failed. Bad username/password.')

    return json.loads(response.content).get('result', None)


def _get_all_devices():
    data = [{'uid': '/zport/dmd/Devices', 'params': {}, 'limit': None}]
    all_devices = _router_request('DeviceRouter', 'getDevices', data=data)
    return all_devices


def find_device(device=None):
    '''
    Find a device in Zenoss. If device not found, returns None.

    Parameters:
        device:         (Required) The device name in Zenoss

    CLI Example:
        salt-run zenoss.find_device device=saltmaster
    '''
    all_devices = _get_all_devices()
    for dev in all_devices['devices']:
        if dev['name'] == device:
            # We need to save the hash for later operations
            dev['hash'] = all_devices['hash']
            log.info('Found device %s in Zenoss', device)
            return dev

    log.info('Unable to find device %s in Zenoss', device)
    return False


def device_exists(device=None):
    '''
    Check to see if a device already exists in Zenoss.

    Parameters:
        device:         (Required) The device name in Zenoss

    CLI Example:
        salt-run zenoss.device_exists device=saltmaster
    '''
    if find_device(device):
        return True
    return False


def add_device(device=None, device_class=None, collector='localhost', prod_state='Production'):
    '''
    A function to connect to a zenoss server and add a new device entry.

    Parameters:
        device:         (Required) The device name in Zenoss
        device_class:   (Required) The device class to use. If none, will determine based on kernel grain.
        collector:      (Optional) The collector to use for this device. Defaults to 'localhost'.
        prod_state:     (Optional) The prodState to set on the device. If none, defaults to Production

    CLI Example:
        salt-run zenoss.add_device device=saltmaster device_class='/Server/Linux'
    '''

    log.info('Adding device %s to zenoss', device)
    data = dict(deviceName=device, deviceClass=device_class, model=True, collector=collector, productionState=PROD_STATES[prod_state])
    response = _router_request('DeviceRouter', 'addDevice', data=[data])
    return response


def set_prod_state(prod_state, device=None):
    '''
    A function to set the prod_state in zenoss.

    Parameters:
        prod_state:     (Required) String value of the state
                        - Production
                        - Pre-Production
                        - Test
                        - Maintenance
                        - Decommissioned

        device:         (Required) The device name in Zenoss

    CLI Example:
        salt-run zenoss.set_prod_state prod_state=1000 device=saltmaster
    '''

    device_object = find_device(device)

    if not device_object:
        return "Unable to find a device in Zenoss for {0}".format(device)

    log.info('Setting prodState to %d on %s device', prod_state, device)
    data = dict(uids=[device_object['uid']], prodState=PROD_STATES[prod_state], hashcheck=device_object['hash'])
    return _router_request('DeviceRouter', 'setProductionState', [data])


def get_decomm():
    '''
    A function to get all decommissioned devices in Zenoss.

    CLI Example:
        salt-run zenoss.get_decomm

    '''

    log.info('Get all decommissioned devices from Zenoss')

    decomm_device = []
    all_devices = _get_all_devices()
    for dev in all_devices['devices']:
        if dev['productionState'] == PROD_STATES['Decommissioned']:
            decomm_device.append(dev['name'])

    if decomm_device.__len__() > 0:
        return decomm_device
    else:
        return 'No devices returned'
        log.info(dev['hash'])

    return True


def send_event(summary, device, severity, evclasskey=None, evclass=None, component=None):
    '''
    required  summary, device, severity

    '''

    data = [{
        'summary': summary,
        'device': device,
        'component': component,
        'severity': severity,
        'evclasskey': evclasskey,
        'evclass': evclass}]
    ret = _router_request('EventsRouter', 'add_event', data=data)

    return ret
