function updateStep(obj,currentStep,varargin)
  % updateStep(currentStep)
  % updateStep(currentStep,maxStep)
  %
  % Update the currentStep property and optionally update the maxStep property.
  % The new progressFraction is computed and the progression texts are updated 
  % accordingly. The displayed text is updated.

  if nargin == 3
    obj.maxStep = varargin{1};
  end
  obj.currentStep = currentStep;

  obj.updatePercentText();
  obj.updateProgressBarText();
  obj.updateStepText();

  obj.print()
end