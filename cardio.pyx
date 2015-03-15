import sys

from PIL import Image

from cython cimport sizeof
from libcpp cimport bool

cimport dmz

from dmz cimport IPL_DEPTH_8U
from dmz cimport IplImage
from dmz cimport ScannerState
from dmz cimport FrameOrientation
from dmz cimport FrameOrientationPortrait
from dmz cimport FrameOrientationPortraitUpsideDown
from dmz cimport FrameOrientationLandscapeRight
from dmz cimport FrameOrientationLandscapeLeft
from dmz cimport FrameScanResult
from dmz cimport ScannerResult
from dmz cimport cvSize
from dmz cimport cvCreateImageHeader
from dmz cimport cvReleaseImageHeader
from dmz cimport cvReleaseImage
from dmz cimport dmz_context
from dmz cimport dmz_edges
from dmz cimport dmz_corner_points
from dmz cimport dmz_detect_edges

class RequirementMissing(Exception):
    pass

def process():
    if dmz.dmz_has_opencv() != 1:
        raise RequirementMissing("OpenCV not found")

    image = Image.open('creditcard.bmp').convert('YCbCr')
    width, height = image.size
    print "Image size:", (width, height)

    cdef IplImage* y = cvCreateImageHeader(cvSize(width, height), IPL_DEPTH_8U, 1)
    cdef IplImage* cb = cvCreateImageHeader(cvSize(width / 2, height / 2), IPL_DEPTH_8U, 1)
    cdef IplImage* cr = cvCreateImageHeader(cvSize(width / 2, height / 2), IPL_DEPTH_8U, 1)

    y_image, cb_image, cr_image = image.split()

    y_data = y_image.tobytes()
    y.imageData = y_data

    cb_data = cb_image.tobytes()
    cb.imageData = cb_data

    cr_data = cr_image.tobytes()
    cr.imageData = cr_data

    cdef float focus_score = dmz.dmz_focus_score(y, False)
    print "Focus score:", focus_score

    cdef dmz_edges found_edges
    cdef dmz_corner_points corner_points
    cdef FrameOrientation orientation = FrameOrientationLandscapeRight
    cdef bool card_detected = dmz_detect_edges(y, cb, cr, orientation, &found_edges, &corner_points)
    # cvReleaseImage(&cb)
    # cvReleaseImage(&cr)
    print "Card detected:", card_detected
    print "Found all edges:", dmz.dmz_found_all_edges(found_edges)

    cdef dmz_context* context = dmz.dmz_context_create()
    cdef IplImage* card_y = NULL
    dmz.dmz_transform_card(context, y, corner_points, orientation, False, &card_y)
    # cvReleaseImageHeader(&y)

    cdef FrameScanResult result
    result.focus_score = focus_score
    result.flipped = False

    cdef ScannerState scanner_state
    dmz.scanner_initialize(&scanner_state)
    dmz.scanner_add_frame_with_expiry(&scanner_state, card_y, True, &result)
    dmz.scanner_add_frame_with_expiry(&scanner_state, card_y, True, &result)
    dmz.scanner_add_frame_with_expiry(&scanner_state, card_y, True, &result)
    # cvReleaseImage(&card_y)
    print "Usable:", result.usable
    print "Upside down:", result.upside_down
    print "vseg score:", result.vseg.score

    cdef ScannerResult scan_result
    dmz.scanner_result(&scanner_state, &scan_result)
    # dmz.scanner_destroy(&scanner_state)
    print "Scan complete:", scan_result.complete
    print "# of numbers:", scan_result.n_numbers
    print "Expiry month:", scan_result.expiry_month
    print "Expiry year:", scan_result.expiry_year

    numbers = [scan_result.predictions(x) for x in xrange(scan_result.n_numbers)]
    print numbers

    # dmz.dmz_context_destroy(context)
