function keys = dtmfrun(xx,L,fs,center_freqs,keypresses)
    %DTMFRUN keys = dtmfrun(xx,L,fs)
    % returns the list of key names found in xx.
    % keys = array of characters, i.e., the decoded key names
    % xx = DTMF waveform
    % L = filter length
    % fs = sampling freq
    %

    hh = dtmfdesign( center_freqs,L,fs );
    % hh = L by 8 MATRIX of all the filters. Each column contains the
    % impulse response of one BPF (bandpass filter)
    %
    dt_cut = dtmfcut(xx,keypresses,fs); 
    key_list = ...
        ['1','2','3','A';
        '4','5','6','B';
        '7','8','9','C';
        '*','0','#','D'];
    keys = [];
    for i=1:size(dt_cut)
        count = 0;
        coord = zeros(1,2);
        for k = 1:size(hh) 
            sc = dtmfscore(dt_cut(i,:),hh(k,:));
            if(sc == 1)
                count = count + 1;
                coord(count) = (k - ((count-1)*4));
                if (coord(count) < 1 || count == 3)
                    display(['error at ' count ' coordinate']);
                    break;
                end
            end
        end
        keys = [keys, key_list(coord(1),coord(2))];
    end
    .... %<=========================================FILL IN THE CODE HERE
end