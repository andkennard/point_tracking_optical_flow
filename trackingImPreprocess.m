function im_p = trackingImPreprocess(im)
%%% Function to preprocess images before tracking. 

%Currently use a median filter with a 3x3 window to remove hot pixels,
%followed by adaptive background subtraction and histogram equalization (default choices in MATAB)

im_medfilt = medfilt2(im,[3,3]);
lim_upper = double(quantile(im_medfilt(:),0.999));
lim_lower = double(quantile(im_medfilt(:),0.001));
%im_p = adapthisteq(im_medfilt);
if isa(im_medfilt,'uint8')
    im_medfilt=double(im_medfilt);
   
    im_p = uint8((255/(lim_upper - lim_lower)) * (im_medfilt - lim_lower));
elseif isa(im_medfilt,'uint16')
    im_medfilt = double(im_medfilt);
    im_p = uint16((65535/(lim_upper- lim_lower)) * (im_medfilt - lim_lower));
end
end