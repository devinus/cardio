cimport dmz

from dmz cimport dmz_context

class RequirementMissing(Exception):
    pass

def process():
    if dmz.dmz_has_opencv() != 1:
        raise RequirementMissing("OpenCV not found")

    cdef dmz_context* context = dmz.dmz_context_create()
    dmz.dmz_context_destroy(context)
