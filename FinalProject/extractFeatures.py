# Christian Sherland
# Sameer Chauhan
# Michael Scibor
#
# getData.py
#   Accepts a web url and gets features on all
#   image anchor tags on the page to classify
#   as ad or not ad

from bs4 import BeautifulSoup
import urllib2
import csv
import sys
import re

if __name__ == '__main__':
    # Parse webpage specified in arg 1
    url = sys.argv[1]

    try:
        content = urllib2.urlopen(url).read()
    except:
        print 'Could not open url'
        exit(-1)
    soup = BeautifulSoup(content)

    # for div in divs:
    #     if div.find('a'):
    #         print(div.find('a').get('href'))
    #     if div.find('img'):
    #         print(div.find('img').get('height'))
    #         print(div.find('img').get('width'))
    #         print(div.find('img').get('height'))


    # .find returns first instance of tag
    # .find_all returns all of them
    # general layout of AD:

    # <a href="Link">
    #       <img src="source" width="W" height="H" alt="ALT"/>
    # </a>
    # Want to find image tags WITHIN an anchor

    # create list of anchors which contain an image
    anchors = [a for a in soup.find_all('a') if a.find('img') ]

    adData = []

    for a in anchors:
        href, imgH, imgW, alt = 0,0,0,0 # Reset values each time
        if a.find('img'):
            print("Found an image")
            href = a.get('href')
            txt  = a.text
            src  = a.find('img').get('src') if a.find('img').get('src') else a.find('img').get('imgsrc')
            imgH = a.find('img').get('height')
            imgW = a.find('img').get('width')
            alt  = a.find('img').get('alt')

            print(href)
            print(txt if txt !="" else "NOTEXT")
            print(src)
            print(imgH)
            print(imgW)
            print(alt if alt != "" else "NOALT")


        # If value is missing continue (almost always mising)
        if not (href and imgW and imgH and alt):
            print("Missing Component\n\n")
            continue

        # Calculate aspect ratio to 3 decimal places
        aspect = format(imgH/float(imgW), '.3f')

        # Local?
        print href

        # Translate data to boolean features
        alt = alt.lower()
        ad = int('ad' in alt)

        # Create list of features for page
        linkData = [imgW,imgH, aspect, ad]

        # Add element to dataset
        adData.append(linkData)
    
    
    # Write data to csv for classification by MATLAB
    with open('urlData.csv', 'wb') as csvfile:
        writer = csv.writer(csvfile, delimiter=',', quotechar=' ', quoting=csv.QUOTE_MINIMAL)
        writer.writerows(adData)

