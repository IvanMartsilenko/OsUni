import time
import sys, os
from datetime import datetime, timedelta
from threading import Thread
import numpy as np


def calculation(filename):
	t_0 = datetime.now()
	outfile = str("./output") + str(os.getpid()) + ".txt"
	with open(filename, 'r') as f:
		_sequence = [int(item) for item in f.read().split()]
	_quantity = float(len(_sequence))
	_sum = float(sum(_sequence))
	_avarage = float(np.mean(_sequence))
	t_1 = datetime.now()
	with open(outfile, "a+") as f:
		f.write("quantity, sum, avarage: " + str(_quantity)+ " " + str( _sum)+ " " + str (_avarage))
		f.write(" Execution time: %s\n" % str(t_1 - t_0))
		f.close()


if __name__ == "__main__":
	thread = Thread(target=calculation, args=(sys.argv[1], ))
	thread.start()
	thread.join()
