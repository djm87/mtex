function ind = subsind(grains,subs)

% dermine grains by x,y coordinates
if numel(subs)==2 && all(cellfun(@isnumeric, subs))
  ind = grains.findByLocation([subs{:}]);
  return
end

ind = true(length(grains),1);
      
for i = 1:length(subs)
  
  if ischar(subs{i}) && strcmpi(subs{i},'indexed')
  
    ind = ind & grains.isIndexed;
  
  elseif ischar(subs{i}) || iscellstr(subs{i})
    
    miner = ensurecell(subs{i});
    alt_mineral = cellfun(@num2str,num2cell(grains.phaseMap),'Uniformoutput',false);
    phases = false(length(grains.phaseMap),1);
    
    for k=1:numel(miner)
      phases = phases | ~cellfun('isempty',regexpi(grains.mineralList(:),['^' miner{k}])) | ...
        strcmpi(alt_mineral,miner{k});
    end
    ind = ind & phases(grains.phaseId(:));
    
    %   elseif isa(subs{i},'grain')
    
    %     ind = ind & ismember(ebsd.options.grain_id,get(subs{i},'id'))';
    
  elseif isa(subs{i},'logical')
    
    sub = any(subs{i}, find(size(subs{i}')==max(size(ind)),1));
    
    ind = ind & reshape(sub,size(ind));
    
  elseif isnumeric(subs{i})
    
    if any(subs{i} <= 0 | subs{i} > length(grains))
      error('Out of range; index must be a positive integer or logical.')
    end
    
    iind = false(size(ind));
    iind(subs{i}) = true;
    ind = ind & iind;
    
  elseif isa(subs{i},'polygon')
    
    ind = ind & inpolygon(grains,subs{i})';
    
  end
end
end
