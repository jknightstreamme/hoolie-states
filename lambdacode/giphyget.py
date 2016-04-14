import requests
import sys

apikey = 'dc6zaTOxFJmzC'
hostid = 'http://api.giphy.com/v1/gifs/'

def getgif(giphy):
    '''
    Create a session to giphy
    '''
    url = "{0}search?q={1}&api_key={2}".format(hostid, giphy, apikey)
    session = requests.session()
    response = session.get(url)
    gifurl = response.json()['data'][1]['images']['original']['url']
    return gifurl


if __name__ == "__main__":

    giphy = sys.argv[1:]
    print getgif(giphy)