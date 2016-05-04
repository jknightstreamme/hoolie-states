'''
Windows Service Management
'''

# Import python libs
import logging
import re

# Import salt libs
import salt.utils

log = logging.getLogger(__name__)


# Define the module's virtual name
__virtualname__ = 'win_certmgr'


def __virtual__():
    '''
    Only works on Windows systems
    '''
    if salt.utils.is_windows():
        return __virtualname__
    return False


def cert_installed(location, datastore, certpath):
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    # Get the cert subject

    certsubject = __salt__['win_certmgr.view_certfile'](certpath=certpath)

    # Get a list of cert subject installed

    certlist = __salt__['win_certmgr.list_certs'](location=location, datastore=datastore)

    # check to see if cert is already installed

    if certsubject in certlist:
        ret['comment'] = "{0} is already installed".format(certsubject)

    else:
        addcert = __salt__['win_certmgr.add_cert'](location=location, datastore=datastore, certpath=certpath)
        ret['result'] = True
        ret['changes'] = {'results': '{0}'.format(addcert)}
        ret['comment'] = "{0} has been installed".format(certsubject)

    return ret
