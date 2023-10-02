import java.util.Random;
public Matrix make1DtoMatrix(double[] matrix){
        double[][] arr = new double[matrix.length][1];
        for(int i = 0 ; i < matrix.length ; i++){
            arr[i][0] = matrix[i];
        }
        return make2DtoMatrix(arr);
    }
    public Matrix make2DtoMatrix(double[][] matrix){
        return new Matrix(matrix.length, matrix[0].length, matrix);
    }

public class NeuralNetwork {
    /*
      This is only a 3 layered network
      1 input layer
      1 hidden layer
      1 output layer
    */
    private int nInput, nHidden, nOutput;
    private double learningRate;
    private int SEED;

    private Matrix weights_IH, bias_H;
    private Matrix weights_HO, bias_O;


    public NeuralNetwork(int nInput, int nHidden, int nOutput, double learningRate, int seed) {
        this.nInput = nInput;
        this.nHidden = nHidden;
        this.nOutput = nOutput;
        this.learningRate = learningRate;
        SEED = seed;
        weights_IH = new Matrix(nHidden, nInput, SEED);
        weights_HO = new Matrix(nOutput, nHidden, SEED);
        bias_H = new Matrix(nHidden, 1, SEED);
        bias_O = new Matrix(nOutput, 1,SEED);
    }

    public Matrix getOutput(double[][] inputs){
         Matrix I = make2DtoMatrix(inputs);
         /*
             H = sigmoid(W_IH*I + B_H);
             O = sigmoid(W_HO*H + B_O);
             return O;
         */
        Matrix H = activateMatrix(weights_IH.multiply(I).add(bias_H));
        Matrix O = activateMatrix(weights_HO.multiply(H).add(bias_O));
        return O;
    }
    public void train(double[][] inputs, double[][] targets){
        Matrix target = new Matrix(targets.length, targets[0].length,targets);
        Matrix input = new Matrix(inputs.length, inputs[0].length,inputs);
        Matrix hidden = activateMatrix(weights_IH.multiply(input).add(bias_H));
        Matrix output = getOutput(input.matrix);

        Matrix error_output = target.sub(output);
        Matrix error_hidden = weights_HO.transpose().multiply(error_output);

        Matrix gradOfOutput = output.gradOfSigmoid();
        gradOfOutput = gradOfOutput.hadamardProduct(error_output).multiplyScaler(learningRate);
        bias_O = bias_O.add(gradOfOutput);
        gradOfOutput = gradOfOutput.multiply(hidden.transpose());

        Matrix gradOfHidden = hidden.gradOfSigmoid();
        gradOfHidden = gradOfHidden.hadamardProduct(error_hidden).multiplyScaler(learningRate);
        bias_H = bias_H.add(gradOfHidden);
        gradOfHidden = gradOfHidden.multiply(input.transpose());

        weights_IH = weights_IH.add(gradOfHidden);
        weights_HO = weights_HO.add(gradOfOutput);
    }


    public Matrix activateMatrix(Matrix m){
        Matrix  m1 = new Matrix(m.rows,m.cols,SEED);
        for(int i = 0 ; i < m.rows ; i++){
            for(int j = 0 ; j < m.cols ; j++){
                m1.matrix[i][j] = activationFunction(m.matrix[i][j]);
            }
        }
        return m1;
    }
    public double activationFunction(double a){
        double ans = 0;
        ans = 1 / (1 + Math.exp(-a));
        return ans;
    }
    public Matrix make2DtoMatrix(double[][] matrix){
        return new Matrix(matrix.length, matrix[0].length, matrix);
    }
    public void details(){

        System.out.println("Weights Input<--->Hidden");
        weights_IH.printMatrix();
        System.out.println("Weights Hidden<--->Output");
        weights_HO.printMatrix();
        System.out.println("Bias Hidden");
        bias_H.printMatrix();
        System.out.println("Bias Output:");
        bias_O.printMatrix();
    }
    
    public void mutate(float rate){
      
      Matrix adderW_IH = new Matrix(nHidden, nInput, 125);
      Matrix adderW_HO = new Matrix(nOutput, nHidden, 125);
      Matrix adderB_H = new Matrix(nHidden, 1, 125);
      Matrix adderB_O = new Matrix(nOutput, 1, 125);
      for(int i = 0 ; i < nHidden ; i++){
       for(int j = 0 ; j < nOutput ; j++){
          double d = random(1);
          if(random(1) < rate){
            adderW_IH.matrix[i][j] = d;
          }else{
            adderW_IH.matrix[i][j] = 0;
          }
       }
      }
       
      for(int i = 0 ; i < nOutput ; i++){
       for(int j = 0 ; j < nHidden ; j++){
          double d = random(1);
          if(random(1) < rate){
            adderW_HO.matrix[i][j] = d;
          }else{
            adderW_HO.matrix[i][j] = 0;
          }
       }
      }
      
      for(int j = 0 ; j < nHidden ; j++){
         double d = random(1);
         if(random(1) < rate){
           adderB_H.matrix[j][0] = d;
         }else{
           adderB_H.matrix[j][0] = 0;
         }
      }
      
      for(int j = 0 ; j < nOutput ; j++){
        double d = random(1);
        if(random(1) < rate){
         adderB_O.matrix[j][0] = d;
       }else{
          adderB_O.matrix[j][0] = 0;
       }
     }
      
      
      weights_IH = weights_IH.add(adderW_IH);
      weights_HO = weights_HO.add(adderW_HO);
      bias_H = bias_H.add(adderB_H);
      bias_O = bias_O.add(adderB_O);
       println("Mutation Happening");
    }

}

Bird crossOverBird(Bird b1, Bird b2){
  Bird child = new Bird();
  for(int i = 0 ; i < b1.brain.nHidden ; i++){
    for(int j = 0 ; j < b1.brain.nInput ; j++){
      int rand = (random(1) > 0.5) ? 1 : 0;
      if(rand == 0){
        child.brain.weights_IH.matrix[i][j] = b1.brain.weights_IH.matrix[i][j];
      }else{
        child.brain.weights_IH.matrix[i][j] = b2.brain.weights_IH.matrix[i][j];
      }
    }
  }
  
  
  
  for(int i = 0 ; i < b1.brain.nOutput ; i++){
    for(int j = 0 ; j < b1.brain.nHidden ; j++){
      int rand = (random(1) > 0.5) ? 1 : 0;
      if(rand == 0){
        child.brain.weights_HO.matrix[i][j] = b1.brain.weights_HO.matrix[i][j];
      }else{
        child.brain.weights_HO.matrix[i][j] = b2.brain.weights_HO.matrix[i][j];
      }
    }
  }
  
  for(int i = 0 ; i < b1.brain.nHidden ; i++){
    int rand = (random(1) > 0.5) ? 1 : 0;
    if(rand == 0){
      child.brain.bias_H.matrix[i][0] = b1.brain.bias_H.matrix[i][0];
    }else{
      child.brain.bias_H.matrix[i][0] = b2.brain.bias_H.matrix[i][0];
    }
  }
  
  
  for(int i = 0 ; i < b1.brain.nOutput ; i++){
    int rand = (random(1) > 0.5) ? 1 : 0;
    if(rand == 0){
      child.brain.bias_O.matrix[i][0] = b1.brain.bias_O.matrix[i][0];
    }else{
      child.brain.bias_O.matrix[i][0] = b2.brain.bias_O.matrix[i][0];
    }
  }
  
  
  return child;
}

void saveData(long generationNumber, Bird bestBirdOfThatGeneration){
  JSONArray data = new JSONArray();
  
  JSONObject genNumber = new JSONObject();
  genNumber.setLong("genNumber", generationNumber);
  data.setJSONObject(0, genNumber);
  
  JSONArray brain = new JSONArray();
  JSONArray W_IH = new JSONArray();
  
  
}
