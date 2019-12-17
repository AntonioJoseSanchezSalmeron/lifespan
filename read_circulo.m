function imagenComprimida = read_circulo(filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    imageID = fopen(filename);
    imagenComprimida = fread(imageID,'uint8');
    fclose(imageID);
end

