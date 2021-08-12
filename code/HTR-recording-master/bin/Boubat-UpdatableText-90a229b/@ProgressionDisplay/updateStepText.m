function updateStepText(obj)
  % Step text looks like: ' 75/100'
  % and will have a progressFraction = 0.75.

  if not(obj.stepTextIsPrinted)
    obj.stepText = '';
    return
  end

  obj.stepText = sprintf(' %d/%d',obj.currentStep,obj.maxStep);
end
