import java.util.Random;

class Matrix {
    public int rows, cols, SEED;  
    public Matrix(int rows, int cols, int SEED) {
        this.rows = rows;
        this.cols = cols;
        this.SEED = SEED;
        this.matrix = randomMatrix();
    }
    public double[][] matrix;
    public Matrix(int rows, int cols, double[][] matrix) {
        this.rows = rows;
        this.cols = cols;
        this.matrix = matrix;
    }
    public double[][] randomMatrix(){
        double[][] matrix = new double[rows][cols];
        Random r = new Random(SEED);
        for(int i = 0 ; i < rows ; i++){
            for(int j = 0 ; j < cols ; j++){
                matrix[i][j] = r.nextDouble(-1,1.000000001);
            }   
        }
        return matrix;
    }
    public Matrix transpose(){
        Matrix transpose = new Matrix(cols, rows, SEED);
        for(int i = 0 ; i < cols ; i++){
            for(int j = 0 ; j < rows ; j++){
                transpose.matrix[i][j] = matrix[j][i];
            }
        }
        return transpose;
    }
    public void fillMatrix(double k){
        for(int i = 0 ; i < rows ; i++){
            for(int j = 0 ; j < cols ; j++){
                matrix[i][j] = k;
            }
        }
    }

    public Matrix gradOfSigmoid(){
        Matrix grad = new Matrix(rows,cols,matrix);
        for(int i = 0 ; i < rows ; i++){
            for(int j = 0 ; j < cols ; j++){
                grad.matrix[i][j] = matrix[i][j] * (1 - matrix[i][j]);
            }
        }
        return grad;
    }
    public Matrix multiply(Matrix m1){
        if(cols != m1.rows){
            throw new RuntimeException("These matrices cannot be multiplied with these dimensions.");
        }
        Matrix ans = new Matrix(rows, m1.cols, SEED);
        for(int i = 0 ; i < rows ; i++){ 
            for(int j = 0 ; j < m1.cols ; j++){
                double a = 0;
                for(int k = 0 ; k < m1.rows ; k++){
                    a += matrix[i][k] * m1.matrix[k][j];
                }
                ans.matrix[i][j] = a;
            }
        }

        return ans;
    }

    public Matrix multiplyScaler(double k){
        Matrix ans = new Matrix(rows,cols,matrix);
        for(int i = 0 ; i < rows ; i++){
            for(int j = 0 ; j < cols ; j++){
                ans.matrix[i][j] = k*matrix[i][j];
            }
        }
        return ans;
    }

    public Matrix hadamardProduct(Matrix m1){
        if(rows != m1.rows || cols != m1.cols){
            throw new RuntimeException("Not Equal Dimensions");
        }
        Matrix ans = new Matrix(rows , cols , SEED);
        for(int i = 0 ; i < rows ; i++){
            for(int j = 0 ; j < cols ; j++){
                ans.matrix[i][j] = matrix[i][j] * m1.matrix[i][j];
            }
        }

        return ans;
    }

    public Matrix add(Matrix m1){
        if(rows != m1.rows || cols != m1.cols){
            throw new RuntimeException("Not Equal Dimensions");
        }
        Matrix ans = new Matrix(rows, m1.cols, SEED);
        for(int i = 0 ; i < rows ; i++){ 
            for(int j = 0 ; j < cols ; j++){
                ans.matrix[i][j] = matrix[i][j] + m1.matrix[i][j];
            }
        }

        return ans;
    }
    public Matrix sub(Matrix m1){
        if(rows != m1.rows || cols != m1.cols){
            throw new RuntimeException("Not Equal Dimensions");
        }
        Matrix ans = new Matrix(rows, m1.cols, SEED);
        for(int i = 0 ; i < rows ; i++){ 
            for(int j = 0 ; j < cols ; j++){
                ans.matrix[i][j] = matrix[i][j] - m1.matrix[i][j];
            }
        }

        return ans;
    }

    public void printMatrix(){
        for(int i = 0 ; i <rows ; i++){
            for(int j = 0 ; j < cols ; j++){
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }
        System.out.println();
    }
    
    
}
