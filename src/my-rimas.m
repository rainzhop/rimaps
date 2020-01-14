clear
pkg load image
pkg load ltfat

pic_origin = imread('<input-pic>');
%pic_origin = rgb2gray(pic_origin);
[row_cnt, col_cnt] = size(pic_origin);
%bgc = ceil(mean(pic_origin(:)));
bgc = sort(pic_origin(:))(ceil(row_cnt * col_cnt / 2));
mask_origin = ones(row_cnt, col_cnt);

xx = 0;
rv = [];
figure;
for angle = 0:1:180-1
  fprintf("process angle = %d...\n", angle);
  pic = imrotate(pic_origin, -angle, 'nearest', 'crop');
  mask = imrotate(mask_origin, -angle, 'nearest', 'crop');
  
  [row_cnt, col_cnt] = size(pic);
  pic = pic(ceil(row_cnt*1/4):floor(row_cnt*3/4), ceil(row_cnt*1/4):floor(row_cnt*3/4));
  
  [row_cnt, col_cnt] = size(pic);
  vpic = [];
  for ii = 1:1:row_cnt
    row = pic(ii, :);
    %row = repmat(row, 1,100);
    row = double(row);
    %mask_row = mask(ii, :);
    %row(mask_row==0) = bgc;
    %pic(ii, :) = row;
    vrow = fft(row);
    vrow = 2*vrow(2:end/2+1);
    vrow = vrow(2:end);
    vpic = [vpic;vrow];
  end
  vpic_mean = mean(vpic);
  A = abs(vpic_mean).^2;
  
  if mod(angle, 30) == 0
    subplot(2, 6, xx+1)
    imshow(pic)
    subplot(2, 6, xx+2)
    plot(A)
    t = sprintf("angle = %d", angle);
    title(t)
    xx = xx + 2;
  end
  
  M = max(A);
  %M = sum(A);
  rv = [rv, M];
end

rv = normalize(rv, 'inf');

figure;
plot(rv)
axis([0 180])
