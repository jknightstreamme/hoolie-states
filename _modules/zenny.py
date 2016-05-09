'''
Module to manage Zenny

'''



from __future__ import absolute_import


# Import salt libs
import salt.utils
import logging

log = logging.getLogger(__name__)

try:
    import RPi.GPIO as GPIO
    import pyttsx
    HAS_LIBS = True
except ImportError:
    HAS_LIBS = False


# Define the module's virtual name
__virtualname__ = 'zenny'


def __virtual__():
    if HAS_LIBS:
        return __virtualname__


def _session():
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(11, GPIO.OUT)
    GPIO.setup(13, GPIO.OUT)
    GPIO.setup(15, GPIO.OUT)

    GPIO.output(11, 1)
    GPIO.output(13, 1)
    GPIO.output(15, 1)

    engine = pyttsx.init()
    engine.setProperty('rate', 100)
    engine.setProperty('volume', 10)

    return


def setcolor(colorint=111):

    GPIO.output(11, int(colorint[0]))
    GPIO.output(13, int(colorint[1]))
    GPIO.output(15, int(colorint[2]))


def statusupdate(color='green'):

    _session()

    if color == 'blue':
        setcolor('010')

    if color == 'red':
        setcolor('100')

    if color == 'green':
        setcolor('001')

    return


def say(msg='Testing the system'):

    engine = pyttsx.init()
    engine.say(msg)
    engine.runAndWait()

    return


def cleanup():

    _session()
