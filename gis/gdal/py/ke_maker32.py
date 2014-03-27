from osgeo import ogr
from osgeo import gdal
import numpy
import sys
import struct

WIDTH = 256
HEIGHT = 256
RESOLUTION = 32

def interpolate(array_2d,regionWidth,regionHeight,resolution):
	"""
	array_2d is a (256+32*2)*(256+32*2) 2-dimentional array of numpy. This function use bilinear method to interpolate the array.
	The precision of the array is 32*32, which implies there are (8+2)*(8+2)=100 kinds of values in the array.
	For example, all elements of array_2d[0:32, 0:32] have the same value, and array_2d[16,16] is treated as the basis point of this 32*32 block. 
	For any element except marginal elements 16 away from any border, it uses 4 nearest basis points to interpolate its value.
	"""
	#range(16, 256+32, 32)
	#16 deals with the start, 256+32 deals with the end, 32 is the step
	for x in range(resolution>>2, regionWidth+resolution, resolution): 
		for y in range(resolution>>2, regionHeight+resolution, resolution):	#as above
			#lb:leftbottom, rb:rightbottom, lt:lefttop, rt:righttop
			#in fact, the coordinate system is left-top coordinate system, 
			#so bigger y is below smaller y, but I don't want to modify the variables' names anymore
			lb = array_2d[x, y]
			rb = array_2d[x+resolution, y]
			lt = array_2d[x, y+resolution]
			rt = array_2d[x+resolution, y+resolution]
			for xx in range(x, x+resolution):
				for yy in range(y, y+resolution):
					tx = (xx - x) / float(resolution)
					ty = (yy - y) / float(resolution)
					array_2d[xx, yy] = (1-tx) * ((1-ty)*lb + ty*lt) + tx * ((1-ty)*rb + ty*rt) 

def make_r32(dem,regionWidth,regionHeight,resolution):
    band = dem.GetRasterBand(1)

    xoff = 0
    yoff = 0
    xsize = 9
    ysize = 9
    buf_xsize = regionWidth + resolution*2
    buf_ysize = regionHeight + resolution*2 
    datatype = band.DataType  
    data_types ={'Byte':'B','UInt16':'H','Int16':'h','UInt32':'I','Int32':'i','Float32':'f','Float64':'d'}  
    type_struct = data_types[gdal.GetDataTypeName(datatype)]
    print type_struct

    bufferStr = band.ReadRaster(xoff,yoff,xsize,ysize,buf_xsize,buf_ysize,datatype)
    bufferArray = struct.unpack(type_struct *buf_xsize * buf_ysize, bufferStr)
    buffer2d = numpy.array(bufferArray).reshape(buf_xsize, buf_ysize)

    # interpolate data to upgrade from 30m to 1m
    interpolate(buffer2d,regionWidth,regionHeight,resolution)
    #remove buffer
    noBuffer = numpy.vsplit(numpy.hsplit(buffer2d, (resolution, resolution + regionWidth))[1], (resolution, resolution + regionHeight))[1]

    #.r32 file records heightfield from west to east, then from south to north
    r32 = numpy.zeros((regionHeight, regionWidth), dtype=numpy.float32)
    for j in range(regionHeight):
        r32[j] = noBuffer[regionHeight - 1 - j]
    regionName = 'xxx'
    r32.tofile(regionName + ".r32")
    print regionName + ".r32 generated!"

def main():
    dem = gdal.Open('proj.tif')
    make_r32(dem,WIDTH,HEIGHT,RESOLUTION)
    print "Success!"

if __name__ == "__main__":
    main()
