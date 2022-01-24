from myirl.kernel.sig import ConvertibleExpr
from myirl.library.pipeline import *

class PipelineProperty(ConvertibleExpr):
    def __init__(self, pipeline):
        self.pipeline = pipeline
        
    def get_sources(self, sigs):
        pass

    def size(self, effective=None):
        return 1
            
class Phase(PipelineProperty):
    def __init__(self, pipeline, phase):
        self.pipe = pipeline
        self.phase = [ ConstBool(int(i)) for i in reversed(phase) ]
        
    def _convert(self, tgt, in_condition = True):
        bub = self.pipe.bubble
        ce0 = bub[0]
        logic = ce0 == self.phase[0]
        if len(self.phase) > 1:
            for i, p in enumerate(self.phase[1:]):
                logic1 = bub[i+1] == p
                logic = logic & logic1
                
        return logic.convert(tgt, in_condition)

class GetCe(PipelineProperty):
    def __init__(self, pipeline, i):
        self.pipe = pipeline
        self.index = i
        
    def _convert(self, tgt, in_condition = True):
        bub = self.pipe.bubble
        ce0 = bub[self.index]
        return ce0.convert(tgt, in_condition)
    
    def is_signed(self):
        return False
    
    def size(self, eff = None):
        return 1

class MyPipeline(Pipeline):
    
    def get_ce(self, i):
        return GetCe(self, i)
    
    def phase(self, phase):
        return Phase(self, phase)

def pipeline(*args, **kwargs):
    def pipeline_dec(func):
        return MyPipeline(func, *args, **kwargs)

    return pipeline_dec
