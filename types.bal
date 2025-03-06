type ErrorMessage record {
    string message;
    string severity;
    string locationString;
    int locationLine;
    int locationCol;
};