# -*- coding: utf-8 -*-
'''
Microsoft Certificate manager

:platform:      Windows

.. versionadded:: Boron

NOTES: https://blogs.technet.microsoft.com/scotts-it-blog/2014/12/30/working-with-certificates-in-powershell/

'''


from __future__ import absolute_import


# Import salt libs
import salt.utils

# Define the module's virtual name
__virtualname__ = 'win_certmgr'


def __virtual__():
    '''
    Load only on Windows
    '''
    if salt.utils.is_windows():
        return __virtualname__
    return False


def _srvmgr(func):
    '''
    Execute a function from the PKI PS module
    '''

    return __salt__['cmd.run'](
        'Import-Module PKI; {0}'.format(func),
        shell='powershell',
        python_shell=True)


def list_certstores():
    '''
    List all the currently deployed certificates

    CLI Example:

    .. code-block:: bash

        salt '*' win_certmgr.list_certstores
    '''
    pscmd = []
    pscmd.append(r'set-location CERT:\LOCALMACHINE;')
    pscmd.append(r'Get-ChildItem')
    pscmd.append(r' | foreach {')
    pscmd.append(r' $_.Name')
    pscmd.append(r'};')

    command = ''.join(pscmd)
    return _srvmgr(command)


def list_certs(datastore):

    pscmd = []
    pscmd.append(r'set-location CERT:\LOCALMACHINE\{0};'.format(datastore))
    pscmd.append(r'Get-ChildItem')
    pscmd.append(r' | foreach {')
    pscmd.append(r' $_.Subject')
    pscmd.append(r'};')

    command = ''.join(pscmd)
    return _srvmgr(command)


def add_cert(datastore, certpath):

    pscmd = []
    pscmd.append(r'get-childitem -path {0} |'.format(certpath))
    pscmd.append(r'import-certificate -certstorelocation CERT:\LOCALMACHINE\{0};'.format(datastore))

    command = ''.join(pscmd)
    return _srvmgr(command)

