cimport dmz

from dmz cimport dmz_context, ScannerState

class RequirementMissing(Exception):
    pass

def process():
    if dmz.dmz_has_opencv() != 1:
        raise RequirementMissing("OpenCV not found")

    cdef dmz_context* context = dmz.dmz_context_create()
    cdef ScannerState scanner_state

    dmz.scanner_initialize(&scanner_state)
    dmz.scanner_destroy(&scanner_state)
    dmz.dmz_context_destroy(context)
