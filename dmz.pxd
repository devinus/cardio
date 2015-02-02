cdef extern from "card.io-dmz/dmz.h":
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

    dmz_context *dmz_context_create()
    void dmz_context_destroy(dmz_context *dmz)
    void dmz_prepare_for_backgrounding(dmz_context *dmz)

    int dmz_has_opencv()
