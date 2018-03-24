function cut_sigs = dtmfcut(dtmfsig, keypresses, fs)
%     This function will separate the separate DTMF signals from one
%     another. The dtmfsig, is a dial tone, but each band of sinusoids
%     represendts a different key press. This function will take that
%     collection of keypress signals that is the dtmfsig, and put them into
%     a matrix of keypress vectors.
    
    %cut_sigs = zeros( keypresses,(length(dtmfsig)-(keypresses*0.05*fs))/keypresses );
    cut_sigs = [];
    
    for i = 1:keypresses
        first = (((i-1)*.2*fs) + ((i-1)*.05*fs))+i;
        last = ((i*0.2*fs) + ((i-1)*.05*fs)+(i-1));
        first = int64(first);
        last = int64(last);
        cut_sigs = [cut_sigs; dtmfsig(first:last)];
    end
   
end