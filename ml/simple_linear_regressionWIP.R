# Simple Linear Regression on crime data

# Importing the dataset
dataset = read.csv('https://raw.githubusercontent.com/BBC-Data-Unit/unsolved-crime/master/outcomes_by_force.csv')

# Splitting the dataset into the Training set and Test set
# install.packages('caTools')
library(caTools)
#Create a seed so results are consistent with other people using same seed
set.seed(123)
#Split the dataset into a training set (1/3) and a test set (2/3)
split = sample.split(dataset$Salary, SplitRatio = 2/3)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Feature Scaling
# training_set = scale(training_set)
# test_set = scale(test_set)

# Fitting Simple Linear Regression to the Training set
# Specify dependent ~ independent variables, and data (training because we need test separate)
regressor <- lm(formula = Salary ~ YearsExperience,
                data = training_set)

#Use summary() to see details about this model including the coefficient
#Note the 3 stars/asterisks in this:
#YearsExperience   9407.0      488.9  19.243 1.87e-13 ***
#That indicates strong significance
#Likewise P value
summary(regressor)

# Predicting the Test set results
y_pred = predict(regressor, newdata = test_set)

# Visualising the Training set results
library(ggplot2)
ggplot() +
  geom_point(aes(x = training_set$YearsExperience, y = training_set$Salary),
             colour = 'red') +
  geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
            colour = 'blue') +
  ggtitle('Salary vs Experience (Training set)') +
  xlab('Years of experience') +
  ylab('Salary')

# Visualising the Test set results
library(ggplot2)
ggplot() +
  geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary),
             colour = 'red') +
  geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
            colour = 'blue') +
  ggtitle('Salary vs Experience (Test set)') +
  xlab('Years of experience') +
  ylab('Salary')