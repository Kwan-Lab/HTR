function erase(obj)
    % Erase the dislayed text. Does not delete the UpdatableText.

    fprintf(obj.getFormerTextPrintableDeleter);
    obj.lastPrintLength = 0;
end