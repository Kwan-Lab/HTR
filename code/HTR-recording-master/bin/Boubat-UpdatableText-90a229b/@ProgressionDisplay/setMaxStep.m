function setMaxStep(obj,newMaxStep)
  % maxStep is the high limit of the displayed progression.
  % It is used to compute the progressFraction.

  obj.updateStep(obj.currentStep,newMaxStep)
end