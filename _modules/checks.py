'''
Module to manage Checks

'''

from __future__ import absolute_import
from socket import error as socket_error

# Import salt libs
import salt.utils
import logging

log = logging.getLogger(__name__)

try:
    HAS_LIBS = True
except ImportError:
    HAS_LIBS = False


# Define the module's virtual name
__virtualname__ = 'checks'


def __virtual__():
    if HAS_LIBS:
        return __virtualname__

def http(name, **kwargs):

    try:
        data = __salt__['http.query'](name, **kwargs)

    except socket_error:
        data = 'nogo'

    return data

