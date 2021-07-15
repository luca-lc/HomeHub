import datetime

class Date:
  __now__ = None
  __limit__ = None

  def __init__(self):
    self.__now__ = datetime.datetime.now()
    self.__limit__ = self.__setdatalimit()

  def __setdatalimit(self):
    return (self.__now__) - (datetime.timedelta(days=60))

  def getnow(self):
    return self.__now__.strftime( "%Y%m%d" )

  def getlimittime(self):
    return self.__limit__.strftime( "%Y%m%d" )
