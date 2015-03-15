from PIL import Image

from libcpp cimport bool

cimport dmz

from dmz cimport IPL_DEPTH_8U
from dmz cimport IplImage
from dmz cimport ScannerState
from dmz cimport FrameOrientation
from dmz cimport FrameOrientationLandscapeRight
from dmz cimport cvSize
from dmz cimport cvCreateImageHeader
from dmz cimport cvReleaseImageHeader
from dmz cimport dmz_context
from dmz cimport dmz_edges
from dmz cimport dmz_corner_points
from dmz cimport dmz_detect_edges

class RequirementMissing(Exception):
    pass

def process():
    if dmz.dmz_has_opencv() != 1:
        raise RequirementMissing("OpenCV not found")

    cdef dmz_context* context = dmz.dmz_context_create()
    cdef ScannerState scanner_state

    # image_data = <bytes> open('creditcard.jpg', 'r').read()
    image = Image.open('creditcard.jpg')
    width, height = image.size

    cdef IplImage* y_image = cvCreateImageHeader(cvSize(width, height), IPL_DEPTH_8U, 1)
    cdef IplImage* cbcr = cvCreateImageHeader(cvSize(width / 2, height / 2), IPL_DEPTH_8U, 2)
    cdef IplImage* cb
    cdef IplImage* cr

    tmp = <bytes> image.convert('YCbCr').tobytes()
    cdef char* image_data = tmp
    y_image.imageData = image_data
    cdef char* tmp2 = (<char*>image_data) + <int>width * <int>height
    cdef char* cbcr_image_data = tmp2
    cbcr.imageData = cbcr_image_data

    dmz.dmz_deinterleave_uint8_c2(cbcr, &cr, &cb)
    cvReleaseImageHeader(&cbcr)

    cdef dmz_edges found_edges
    cdef dmz_corner_points corner_points
    cdef FrameOrientation orientation = FrameOrientationLandscapeRight
    cdef bool cardDetected = dmz_detect_edges(y_image, cb, cr, orientation, &found_edges, &corner_points)

    dmz.scanner_initialize(&scanner_state)
    dmz.scanner_destroy(&scanner_state)
    dmz.dmz_context_destroy(context)
