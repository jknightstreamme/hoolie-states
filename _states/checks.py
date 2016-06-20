'''
Updates from events

'''
import logging

# Import salt libs
import salt.utils

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


def http(name, status):

    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    kwargs['status'] = True
    #data = __salt__['http.query'](name, **kwargs)

    #if data.get('status', '') == status:
    __salt__['mine.send']('http.query', name=name, **kwargs)

    
    ret['comment'] = 'http status updated'

    return ret
