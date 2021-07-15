import os
import sys

import Date


class Dirs:
    __mypath__ = None
    __date__ = None

    def __init__(self, mypath):
        self.__mypath__ = mypath
        self.__date__ = Date.Date()

    def deleteunuseddir(self, path):
        iterator = os.scandir(path)
        for dates in iterator:
            if( dates.is_dir() and (os.path.basename(dates) < self.__date__.getlimittime()) ):
                tmp = os.path.abspath(dates)
                command = "rm -rf " + tmp
                os.system( command )
        iterator.close()


    def scancameras( self ):
        try:
            iterator = os.scandir(self.__mypath__)
        except FileNotFoundError:
            sys.stderr.write( "Problem to open folder" )
            exit(-1)
        for camera in iterator:
            if (camera.is_dir()):
                self.deleteunuseddir( os.path.abspath(camera) )
        iterator.close()
