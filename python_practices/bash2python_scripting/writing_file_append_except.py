import os

def main():
    try:
        if os.path.isfile('guru99.txt'):
            f=open("guru99.txt","a")
        else:
            f= open("guru99.txt","w+")
        
        for i in range(10):
            f.write("This is line %d\r\n" % (i+1))
        f.close()
        #Open the file back and read the contents
        f=open("guru99.txt", "r")
        if f.mode == 'r':
            contents =f.readlines()
            for line in contents:
                line = line.strip()
                print (line)
    except ValueError:
        print("There was an error")
        raise
    except IOError as e:
        print "I/O error({0}): {1}".format(e.errno, e.strerror)
        raise
    except:
        print "Unexpected error:", sys.exc_info()[0]
        raise
    finally:
        f.close()

if __name__== "__main__":
    main()

