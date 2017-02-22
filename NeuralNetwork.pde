/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Filename: NeuralNetwork.pde
Version: 1.1.0
Author: Sean Allen
Last Modified: ~2/1/17
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class NeuralNetwork
{
  Neuron[][] neuron;       // 2D matrix of neurons
  int nRows;               // Number of rows of neurons
  int nColumns;            // Number of colums of neurons
  float LC;                // Learning constant
  float LT;                // Learning Threshold
  boolean BP_State;        // Controls whether or not the back propagation algorithm is active.
  boolean trainingState = true;   
  int trainingEnd;
  
  float guess;
  float error;
  float weightChange;
  float maxWeight = 3;

  NeuralNetwork(int nRows_, int nColumns_, float LC_, float LT_, boolean BP_State_)
  {
    nRows = nRows_;
    nColumns = nColumns_;
    LC = LC_;
    LT = LT_;
    BP_State = BP_State_;

    // Create 2D Neuron array
    neuron = new Neuron[nRows][nColumns];
  }

  void populate(int x_, int y_, int spacing)
  {
    int x = x_;
    int y = y_;
    int space = spacing;

    // Place neurons into a grid.
    for (int i = 0; i < nRows; i++)
    {
      for (int ii = 0; ii < nColumns; ii++)
      {
        // Create the neuron at new location.
        /*               
         Neuron(int x_, int y_, int inputs_, boolean outputBinary, int bias_ int range_, float threshold_, int bsize, 
         int recharge_, float hp_, int hp_period_, float hp_gain_, float hp_loss_)
         1.x  2.y  3.inputs 4.outputBinary 5.bias 6.range  7.threshold  8.size  9.recharge  10.hp  11.hp_period  12.hp_gain  13.hp_loss  14.learningConstant  15. learningThreshold      
         */
        neuron[i][ii] = new Neuron(x, y, 3, false, 1, .3, .5, 10, 10, 255, 100, 10, 1, LC, LT);

        // Increment position and count.
        x += space;
        if (ii == nColumns - 1) x = x_; //<---- Bug: Spacing when r < c
      }
      y += space;
    }
  }

  void drawNeurons()
  {
    for (int i = 0; i < nRows; i++)
    {
      for (int ii = 0; ii < nColumns; ii++)
      {
        neuron[i][ii].drawNeuron();
      }
    }
  }

  void processNeurons(float error)
  {
    for (int i = 0; i < nRows; i++)
    {
      for (int ii = 0; ii < nColumns; ii++)
      {
        if(neuron[i][ii].fired == true && trainingState == true)
          neuron[i][ii].adjustWeights(error);
        neuron[i][ii].smoothing = neuron[i][ii].smoothing(actMean());
        // Connections for the first row.
        if (i < 1)
        {
          //neuron[i][ii].drawNeuron(); // Calculate output and draw neuron
          if(i < nRows - 1 && ii < nColumns - 1) // Pass the output to apropriate neurons in the next layer
          {
            neuron[i][ii + 1].inputs[1] = neuron[i][ii].output; // Neuron in front
            neuron[i + 1][ii + 1].inputs[2] = neuron[i][ii].output; // Neuron below
            
            //NN.neuron[i][ii + 1].inputKudos[1] = NN.neuron[i][ii].kudos; // Neuron in front
            //NN.neuron[i + 1][ii + 1].inputKudos[2] = NN.neuron[i][ii].kudos; // Neuron below
          }
        }
        // Connections for the last row.
        if (i >= nRows)
        {
          //neuron[i][ii].drawNeuron(); // Calculate output and draw neuron
          if(i < nRows - 1 && ii < nColumns - 1) // Pass the output to apropriate neurons in the next layer
          {
            neuron[i][ii + 1].inputs[1] = neuron[i][ii].output; // Neuron in front
            neuron[i - 1][ii + 1].inputs[0] = neuron[i][ii].output; // Neuron above
            
            //NN.neuron[i][ii + 1].inputKudos[1] = NN.neuron[i][ii].kudos; // Neuron in front
            //NN.neuron[i - 1][ii + 1].inputKudos[0] = NN.neuron[i][ii].kudos; // Neuron above
          }
        }
        // Connecting the rows inbetween.
        if (i >= 1 && i < nRows)
        {
          //neuron[i][ii].drawNeuron(); // Calculate output and draw neuron
          if(i < nRows - 1 && ii < nColumns - 1) // Pass the output to apropriate neurons in the next layer
          {
            neuron[i - 1][ii + 1].inputs[0] = neuron[i][ii].output; // Neuron above
            neuron[i][ii + 1].inputs[1] = neuron[i][ii].output; // Neuron in front
            neuron[i + 1][ii + 1].inputs[2] = neuron[i][ii].output; // Neuron below
            
            //NN.neuron[i - 1][ii + 1].inputKudos[0] = NN.neuron[i][ii].kudos; // Neuron above
            //NN.neuron[i][ii + 1].inputKudos[1] = NN.neuron[i][ii].kudos; // Neuron in front
            //NN.neuron[i + 1][ii + 1].inputKudos[2] = NN.neuron[i][ii].kudos; // Neuron below
          }
        }
      }
    }
  }

  void staticDrawNetwork()
  {
    for (int i = 0; i < nRows; i++)
    {
      for (int ii = 0; ii < nColumns; ii++)
      {
        neuron[i][ii].staticDrawNeuron();
      }
    }
  }


  //-----------------------------------------------------------------------
  // Unfinished functions
  //-----------------------------------------------------------------------
  
    // Weights are adjusted based on "desired" answer
  void trainNetworkOutput(int or, int oc, float desired, float learningThreshold, float learningConstant, char feedDirection, float fuzzLow, float fuzzHigh) {
    int trainingStart;
    if (BP_State == true && trainingState == true)
    {
      //processNeurons();
      guess = neuron[or][oc].output; // Guess the result
      error = desired - guess; // Calculate the error
      float netMean = actMean();
      
      if(abs(error) >= learningThreshold) // Only change weights if the error is outside of the learning threshold.
      {
        trainingState = true;
        trainingStart = millis();
        if(feedDirection == 'F') // Feedforward
        {
          fuzz(fuzzLow, fuzzHigh);
          for(int i = nRows - 1; i >= 0; i--)
            for(int ii = nColumns - 1; ii >=0; ii--)
              // Adjust weights based on weightChange * input
              for (int iii = 0; iii < neuron[i][ii].weights.length; iii++) {
                  float activationMod = neuron[i][ii].activation / netMean;
                  weightChange = learningConstant * error * neuron[i][ii].inputs[iii];
                  neuron[i][ii].weights[iii] += weightChange;
                }
              }
          
        
        if(feedDirection == 'B') // Feedback
        {
          
          fuzz(fuzzLow, fuzzHigh);
          for(int i = 0; i < nRows; i++)
            for(int ii = 0; ii < nColumns; ii++)
              // Adjust weights based on weightChange * input
              for (int iii = 0; iii < neuron[i][ii].weights.length; iii++) {
                float activationMod = neuron[i][ii].activation / netMean;
                weightChange = learningConstant * error * neuron[i][ii].inputs[iii];
                  neuron[i][ii].weights[iii] += weightChange;
              }
        }
      }
      else
      {
        //trainingState = false;
      }
    }
    
  }
 
  /*
  float dopeLC(float activation_)
  {
    return learningConstant * abs(neuron[i][ii].activation
  */
  
  float actMean()
  {
    int count = 0;
    float sum = 0;
    for(int i = 0; i < nRows; i++)
      for(int ii = 0; ii < nColumns; ii++)
      {
        sum += neuron[i][ii].activation;
        count++;
      }
    return sum / count;
  }
      
      
  // Add noise to each neuron's activation.  
  void fuzz(float low, float high)
  {
    for (int i = 0; i <= nRows - 1; i++) // Scan rows
    {
      for (int ii = 0; ii < nColumns - 1; ii++) // Scan columns
      {
        neuron[i][ii].activation += random(low, high);
      }
    }
  }
  
} // End of class