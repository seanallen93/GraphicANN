/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Filename: Trainer.pde
Version: 1.1.0
Author: Sean Allen
Last Modified: 2/13/17
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Table trainingTable;

//-----------------------------------------------------------------------
// Training functions
//-----------------------------------------------------------------------
void netTrainTable(Table table)
{
  
  for(int i = table.getRowCount() - 1; i >= 0; i--)
  {
    int attempt = 0;
    do{
      TableRow row = table.getRow(i);
      //answer = i / 1000;
      answer = row.getFloat("Open");
      
      q1 = i / 1000;
      //q1 = row.getFloat("Open");
      //q2 = row.getFloat("Open");
      drawSynapse();
      
      //fuzzInjection(100);
      processNetwork(net);
      
      NN[net].drawNeurons();
      
      //DEBUG();
    
      guess = NN[net].neuron[outputRow][outputColumn].output;
      error = answer - guess;
      attempt++;
      
      if(attempt >= 3000)
      {
        break;
      }
      processNetwork(net);
      
      println("Row: " + i + "\t Guess: " + guess + "\t Answer: " + answer + "\t Error: " + error + "\t Attempt: " + attempt);
    }
    while(abs(error) >= .1);
    
  }
}
    
    
void netTrainAddition(float q1, float q2)
{
  float answer = q1 + q2;
  
  if(NN[net].trainingState == true)
    NN[net].trainNetworkOutput(4, 9, answer, learningThreshold, learningConstant, feedDirection, fuzzLow, fuzzHigh);
}

void neuronTrainAddition(float q1, float q2, int n)
{
  answer = q1 + q2;
  guess = NN[n].neuron[outputRow][outputColumn].output;
  error =  answer - guess;
}

void neuronTrainMultiplication(float q1, float q2, int n)
{
  answer = q1 * q2;
  guess = NN[n].neuron[outputRow][outputColumn].output;
  error =  answer - guess;
}