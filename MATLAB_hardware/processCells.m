%% 分類用的function
function class_out = processCells(input_cell_1, input_cell_2, input_cell_3)
    
    % Kernel Sh and Sv
    Sh = [1, 0, 1;
          1, 0, 1; 
          1, 0, 1];
    Sv = [1, 1, 1;
          0, 0, 0; 
          -1, -1, -1];
    
    % 計算 gh 和 gv
    gh = sum(sum(input_cell_1 .* Sh)) + sum(sum(input_cell_2 .* Sh)) + sum(sum(input_cell_3 .* Sh));
    gv = sum(sum(input_cell_1 .* Sv))  +sum(sum(input_cell_2 .* Sv)) + sum(sum(input_cell_3 .* Sv));
    
    % 計算 mp
    mp = abs(gh) + abs(gv);
    
    % 定義 Sx 和 Sy
    Sx = [0, 0, 0;
          1, 0, -1; 
          0, 0, 0];
    Sy = [0, 1, 0;
          0, 0, 0; 
          0, -1, 0];
    
    % 計算 gx 和 gy
    gx = sum(sum(input_cell_1 .* Sx)) + sum(sum(input_cell_2 .* Sx)) + sum(sum(input_cell_3 .* Sx));
    gy = sum(sum(input_cell_1 .* Sy)) + sum(sum(input_cell_2 .* Sy)) + sum(sum(input_cell_3 .* Sy));
    
    T = 2.15625;
    
    % Processing and writing to TFRecord
    if mp < T
        class_out = 0;
    elseif mp >= T && gy >= 0 && abs(gy) >= abs(gx)
        class_out = 1;
    elseif mp >= T && gy >= 0 && abs(gy) < abs(gx)
        class_out = 2;
    elseif mp >= T && gy < 0 && abs(gy) >= abs(gx)
        class_out = 3;
    elseif mp >= T && gy < 0 && abs(gy) < abs(gx)
        class_out = 4;
    end
end