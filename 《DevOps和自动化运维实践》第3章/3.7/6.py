import urllib2, base64, sys
import getopt
import re

def Usage():
        print "Usage: getWowzaInfo.py -a [active|accepted|handled|request|reading|writting|waiting]"
        sys.exit(2)

def main():
	if len(sys.argv) < 2:
		Usage()
	try:
        	opts, args = getopt.getopt(sys.argv[1:], "a:")
	except getopt.GetoptError:
                Usage()

	# Assign parameters as variables
	for opt, arg in opts :
	        if opt == "-a" :
        	        getInfo = arg

	url="http://127.0.0.1:80/ngserver_status"
	request = urllib2.Request(url)
	result = urllib2.urlopen(request)

	buffer = re.findall(r'\d+', result.read())

	if ( getInfo == "active"):
        	print buffer[0]
	elif ( getInfo == "accepted"):
		print buffer[1]
	elif ( getInfo == "handled"):
	        print buffer[2]
	elif ( getInfo == "requests"):
	        print buffer[3]
	elif ( getInfo == "reading"):
	        print buffer[4]
	elif ( getInfo == "writting"):
	        print buffer[5]
	elif ( getInfo == "waiting"):
	       	print buffer[6]
	else:
        	print "unknown"
	        sys.exit(1)

if __name__ == "__main__":
    main()
