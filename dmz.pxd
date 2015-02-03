from libcpp cimport bool

cdef extern from "dmz/dmz.h":
    cdef int IPL_DEPTH_8U

    cdef enum FrameOrientation:
        pass

    ctypedef struct CvSize:
        int width
        int height

    ctypedef struct IplImage:
        char *imageData

    ctypedef struct dmz_context:
        void *mz

    ctypedef struct ParametricLine:
        float rho
        float theta

    ctypedef struct dmz_found_edge:
        int found
        ParametricLine location

    ctypedef struct dmz_edges:
        dmz_found_edge top
        dmz_found_edge left
        dmz_found_edge bottom
        dmz_found_edge right

    ctypedef struct dmz_point:
        float x
        float y

    ctypedef struct dmz_corner_points:
        dmz_point top_left
        dmz_point bottom_left
        dmz_point top_right
        dmz_point bottom_right

    CvSize cvSize(int width, int height)
    IplImage *cvCreateImageHeader(CvSize size, int depth, int channels)
    void cvReleaseImageHeader(IplImage** image)

    dmz_context *dmz_context_create()
    void dmz_context_destroy(dmz_context *dmz)
    void dmz_prepare_for_backgrounding(dmz_context *dmz)

    int dmz_has_opencv()
    float dmz_focus_score(IplImage *image, bool use_full_image)
    void dmz_deinterleave_uint8_c2(IplImage *interleaved, IplImage **channel1, IplImage **channel2)
    bool dmz_detect_edges(IplImage *y_sample, IplImage *cb_sample, IplImage *cr_sample,
                          FrameOrientation orientation, dmz_edges *found_edges, dmz_corner_points *corner_points)
    void dmz_transform_card(dmz_context *dmz, IplImage *sample, dmz_corner_points corner_points,
                            FrameOrientation orientation, bool upsample, IplImage **transformed)

cdef extern from "dmz/scan/scan.h":
    ctypedef struct ScannerResult:
        pass

    ctypedef struct ScannerState:
        pass

    ctypedef struct FrameScanResult:
        pass

    void scanner_initialize(ScannerState *state)
    void scanner_reset(ScannerState *state)
    void scanner_result(ScannerState *state, ScannerResult *result)
    void scanner_destroy(ScannerState *state)
    void scanner_add_frame_with_expiry(ScannerState *state, IplImage *y, bool scan_expiry, FrameScanResult *result)
