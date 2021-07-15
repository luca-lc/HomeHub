import Dirs
import sys
import os

if __name__ == '__main__':
    if ( len(sys.argv) == 1 ):
        sys.stderr.write( "empty arguments" )
    else:
        if( os.path.basename(sys.argv[1]) == "cctv" ):
            DSD = Dirs.Dirs( sys.argv[1] )
            DSD.scancameras()
            print( "Done" )
        else:
            sys.stderr.write( "uncorrect path" )