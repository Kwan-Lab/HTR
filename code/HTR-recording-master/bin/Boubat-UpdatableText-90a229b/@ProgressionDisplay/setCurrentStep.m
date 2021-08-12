function setCurrentStep(obj,newCurrentStep)
  % currentStep is the current state of the displayed progression.
  % It is used to compute the progressFraction.

  obj.updateStep(newCurrentStep);
end