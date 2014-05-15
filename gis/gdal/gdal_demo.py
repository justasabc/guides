# http://www.gis.usu.edu/~chrisg/python/2009/lectures/ospy_slides4.pdf
# http://geoinformaticstutorial.blogspot.com/2012/09/reading-raster-data-with-python-and-gdal.html
# http://geoexamples.blogspot.com/2012_02_01_archive.html
# http://pcjericks.github.io/py-gdalogr-cookbook/raster_layers.html
# http://www.gdal.org/python/
# http://www.gdal.org/gdal_tutorial.html
# http://www.gdal.org/gdal_8h.html  (GDT_Byte GDT_Float32)
# http://docs.python.org/2/library/struct.html#module-struct (unpack('b'*16,str))
# http://docs.scipy.org/doc/numpy/user/basics.types.html (dtype=numpy.int8 numpy.float32)
# http://gdal.org/python/osgeo.gdal_array-module.html#BandWriteArray
# http://nullege.com/codes/search/gdal.Open.GetRasterBand.ReadAsArray
# http://gis.stackexchange.com/questions/29273/creating-a-multispectral-image-from-scratch


"""
enum  	GDALDataType { 
  GDT_Unknown = 0, GDT_Byte = 1, GDT_UInt16 = 2, GDT_Int16 = 3, 
  GDT_UInt32 = 4, GDT_Int32 = 5, GDT_Float32 = 6, GDT_Float64 = 7, 
  GDT_CInt16 = 8, GDT_CInt32 = 9, GDT_CFloat32 = 10, GDT_CFloat64 = 11, 
  GDT_TypeCount = 12 
}
"""

"""
Format	C Type	Python type	Standard size	Notes
x	pad byte	no value	 	 
c	char	string of length 1	1	 
b	signed char	integer	1	(3)
B	unsigned char	integer	1	(3)
?	_Bool	bool	1	(1)
h	short	integer	2	(3)
H	unsigned short	integer	2	(3)
i	int	integer	4	(3)
I	unsigned int	integer	4	(3)
l	long	integer	4	(3)
L	unsigned long	integer	4	(3)
q	long long	integer	8	(2), (3)
Q	unsigned long long	integer	8	(2), (3)
f	float	float	4	(4)
d	double	float	8	(4)
s	char[]	string	 	 
p	char[]	string	 	 
P	void *	integer	 	(5), (3)
"""

"""
Data type	Description
bool_	Boolean (True or False) stored as a byte
int_	Default integer type (same as C long; normally either int64 or int32)
intc	Identical to C int (normally int32 or int64)
intp	Integer used for indexing (same as C ssize_t; normally either int32 or int64)
int8	Byte (-128 to 127)
int16	Integer (-32768 to 32767)
int32	Integer (-2147483648 to 2147483647)
int64	Integer (-9223372036854775808 to 9223372036854775807)
uint8	Unsigned integer (0 to 255)
uint16	Unsigned integer (0 to 65535)
uint32	Unsigned integer (0 to 4294967295)
uint64	Unsigned integer (0 to 18446744073709551615)
float_	Shorthand for float64.
float16	Half precision float: sign bit, 5 bits exponent, 10 bits mantissa
float32	Single precision float: sign bit, 8 bits exponent, 23 bits mantissa
float64	Double precision float: sign bit, 11 bits exponent, 52 bits mantissa
complex_	Shorthand for complex128.
complex64	Complex number, represented by two 32-bit floats (real and imaginary components)
complex128	Complex number, represented by two 64-bit floats (real and imaginary 
"""

"""
{gdalconst.GDT_Byte: numpy.uint8, gdalconst.GDT_UInt16: numpy.uint16, \
gdalconst.GDT_Int16: numpy.int16, gdalconst.GDT_UInt32: numpy.uint32, \
gdalconst.GDT_Int32: numpy.int32, gdalconst.GDT_Float32: numpy.float32\
, gdalconst.GDT_Float64: numpy.float64, gdalconst.GDT_CInt16: numpy.co\
mplex64, gdalconst.GDT_CInt32: numpy.complex64, gdalconst.GDT_CFloat32\
: numpy.complex64, gdalconst.GDT_CFloat64: numpy.complex128}
"""

import gdal, ogr, os, osr
import numpy 
import struct

"""
    adfGeoTransform[0] /* top left x */
    adfGeoTransform[1] /* w-e pixel resolution */
    adfGeoTransform[2] /* 0 */
    adfGeoTransform[3] /* top left y */
    adfGeoTransform[4] /* 0 */
    adfGeoTransform[5] /* n-s pixel resolution (negative value) */

    Xgeo = GT(0) + Xpixel*GT(1) + Yline*GT(2)
    Ygeo = GT(3) + Xpixel*GT(4) + Yline*GT(5)
"""
def pixel2geo(pixel,gt):
    # pixel = (px,py)
    xgeo = gt[0] + pixel[0] * gt[1]
    ygeo = gt[3] + pixel[1] * gt[5]
    return (xgeo,ygeo)

def geo2pixel(geo,gt):
    # geo = (gx,gy)
    px = (geo[0] - gt[0]) / gt[1] 
    py = (geo[1] - gt[3]) / gt[5] 
    return (int(px), int(py))

def array2raster(newRasterfn,rasterOrigin,pixelWidth,pixelHeight,array):

    cols = array.shape[1]
    rows = array.shape[0]
    originX = rasterOrigin[0]
    originY = rasterOrigin[1]
    dataType = gdal.GDT_UInt16

    driver = gdal.GetDriverByName('GTiff')
    outRaster = driver.Create(newRasterfn, cols, rows, 1, dataType)
    outRaster.SetGeoTransform((originX, pixelWidth, 0, originY, 0, -pixelHeight))
    outband = outRaster.GetRasterBand(1)
    outband.WriteArray(array,)
    outRasterSRS = osr.SpatialReference()
    #outRasterSRS.ImportFromEPSG(4326)
    outRasterSRS.ImportFromEPSG(32650)
    outRaster.SetProjection(outRasterSRS.ExportToWkt())
    outband.FlushCache()

    #output info about dataset
    read_info(outRaster)

    # read data from band
    #read_raster(outband)
    read_raster2(outband)

    #close dataset
    outband = None
    outRaster = None

def read_info(outRaster):
    print "="*20
    print outRaster.RasterXSize, outRaster.RasterYSize, outRaster.RasterCount # 3,3 1
    geotrans = outRaster.GetGeoTransform()
    print geotrans
    proj = outRaster.GetProjectionRef()
    print proj

def test_case():
    rasterOrigin = (0.0,30.0)
    pixelWidth = 10
    pixelHeight = 10
    newRasterfn = 'test.tif'
    array = numpy.array([[ 1, 1, 1],
                      [ 1, 1, 0],
                      [ 1, 0, 0]])
    print '='*20
    print array
    array2raster(newRasterfn,rasterOrigin,pixelWidth,pixelHeight,array) # convert array to raster

def test_case2():
    rasterOrigin = (0,256)
    pixelWidth = 1
    pixelHeight = 1
    newRasterfn = 'test2.tif'
    #array = np.arange(128*128).reshape(128,128)
    array = numpy.arange(256*256).reshape(256,256)
    #array = array.astype(numpy.uint16) # default int64
    print array.dtype
    print '='*20
    print array
    array2raster(newRasterfn,rasterOrigin,pixelWidth,pixelHeight,array) # convert array to raster

"""
scanline = band.ReadRaster( 0, 0, band.XSize, 1, band.XSize, 1, GDT_Float32 )
Note that the returned scanline is of type string, and contains xsize*4 bytes of raw binary floating point data. This can be converted to Python values using the struct module from the standard library:

        import struct
        tuple_of_floats = struct.unpack('f' * b2.XSize, scanline)
"""

def read_raster(band):
    print band.DataType
    datatype = gdal.GetDataTypeName(band.DataType)
    print datatype
    # gdal.GDT_Byte ----> B ---->numpy.uint8
    # gdal.GDT_UInt16 ----> H ---->numpy.uint16
    # gdal.GDT_Byte gdal.GDT_Float32
    # b B f
    # uint8 uint16 uint32 float32
  
    xoff = 0
    yoff = 0
    xsize = 256
    ysize = 2
    buf_xsize = xsize
    buf_ysize = ysize 

    datatype = band.DataType  
    #Conversion between GDAL types and python pack types (Can't use complex integer or float!!)  
    data_types ={'Byte':'B','UInt16':'H','Int16':'h','UInt32':'I','Int32':'i','Float32':'f','Float64':'d'}  
    # type_struct = "H"
    type_struct = data_types[gdal.GetDataTypeName(datatype)]

    bufferStr = band.ReadRaster(xoff,yoff,xsize,ysize,buf_xsize,buf_ysize,datatype)
    bufferArray = struct.unpack(type_struct *buf_xsize * buf_ysize, bufferStr)
    #print bufferArray

    #convert 1-d tuple to 2-d array
    #buffer2d = numpy.array(bufferArray, dtype = type_numpy).reshape(buf_ysize, buf_xsize)
    buffer2d = numpy.array(bufferArray).reshape(buf_ysize, buf_xsize)
    print buffer2d.dtype
    print buffer2d

def read_raster2(band):
    xoff = 0
    yoff = 1
    xsize = 16
    ysize = 2
    buffer2d = band.ReadAsArray(xoff,yoff,xsize,ysize)
    print buffer2d.dtype
    print buffer2d

def read_case():
    infile = 'proj_clip.tif'
    ds = gdal.Open(infile)
    band = ds.GetRasterBand(1)
    buffer2d = band.ReadAsArray(0,0,ds.RasterXSize,ds.RasterYSize)
    print "xsize=",ds.RasterXSize, "ysize", ds.RasterYSize # 47  61
    print "="*20
    print buffer2d.dtype
    print buffer2d.ndim
    print "y:rows=", buffer2d.shape[0], "x:columns=",buffer2d.shape[1]
    print buffer2d.size
    print buffer2d

    band =None
    ds = None

def main():
    #test_case()
    #test_case2()
    read_case()

if __name__ == "__main__":
    main()
