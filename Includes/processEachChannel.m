function [signal, timeStamps, samplingFreq, header] = processEachChannel(fileName)
    
    [timeStamps, channel, samplingFreq, validSamples, signal, header] = Nlx2MatCSC(fileName, [1 1 1 1 1], 1, 1, 1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    % Continuously sampled signal in AD units.
    signal = signal(:)';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    channel      = unique(channel);
    samplingFreq = unique(samplingFreq);
    validSamples = unique(validSamples);
    
    if length(channel) ~= 1
        error('More than one channel identifier has been detected!');
    end

    if length(samplingFreq) ~= 1
        error('More than one sampling frequency has been detected!');
    end
    
    if length(validSamples) ~= 1
        error('More than one number of valid samples per record/chunk has been detected!');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    % Remove the last record/chunk of data.
    timeStamps = timeStamps(1:end-1);
    signal     = signal(1:end - validSamples);
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dt         = 10.0 ^ 6 / samplingFreq * (0:(validSamples - 1))'; % usec.
    timeStamps = repmat(timeStamps, validSamples, 1);               % usec.
    timeStamps = timeStamps + repmat(dt, 1, size(timeStamps, 2));    
    
    timeStamps = timeStamps(:)';
     
     
%       if isempty(strfind(fileName,'CSC31.ncs')) && isempty(strfind(fileName,'CSC23.ncs')) && isempty(strfind(fileName,'CSC24.ncs')) && isempty(strfind(fileName,'CSC26.ncs'))
%         signal     = signal(1:end-512);
%         timeStamps = timeStamps(1:end-512);
%       end
%      
%    if  ~isempty(strfind(fileName,'CSC18.ncs'))  | ~isempty(strfind(fileName,'CSC21.ncs')) % | ~isempty(strfind(fileName,'CSC23.ncs'))| ~isempty(strfind(fileName,'CSC21.ncs'))| ~isempty(strfind(fileName,'CSC26.ncs'))| ~isempty(strfind(fileName,'CSC27.ncs'))
%         signal     = signal(1:end-512);
%         timeStamps = timeStamps(1:end-512);
%    end
% %      
end