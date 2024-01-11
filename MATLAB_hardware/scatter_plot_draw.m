%% 此程式用來繪製影像還原完成後的散點圖

% 指定 LDR 和 HDR 圖像的資料夾路徑
ldrFolder = '../golden/LDR/';
hdrFolder = '../output_matlab_hardware/HDR/';

% 圖像數量
numImages = 13;

% 初始化數據存儲
allLdrValues = [];
allHdrValues = [];

% 循環處理每對圖像
for i = 3:numImages
    % 構建文件路徑
    ldrPath = fullfile(ldrFolder, sprintf('%d.hdr', i));
    hdrPath = fullfile(hdrFolder, sprintf('%d_output.hdr', i));

    % 讀取圖像
    ldrImage = hdrread(ldrPath);
    hdrImage = hdrread(hdrPath);

    % 提取像素值
    allLdrValues = [allLdrValues; ldrImage(:)];
    allHdrValues = [allHdrValues; hdrImage(:)];
end

% 繪製散點圖
scatter(allLdrValues, allHdrValues, '.');
xlabel('LDR Values');
ylabel('HDR Values');
title('LDR to HDR Transfer Function');