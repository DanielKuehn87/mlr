Predicting Outcomes for New Data
================================

This section is pretty straightforward and - as you might have guessed
- deals with predicting target values for new observations. It is
implemented the same way as most of the other predict methods in R, i.e. just 
call [predict](http://berndbischl.github.io/mlr/predict.WrappedModel.html) on the object returned by [train](http://berndbischl.github.io/mlr/train.html) and pass the data to be predicted.


Quick start
-----------

### Classification example

Let's train a Linear Discriminant Analysis on the ``iris`` data and make predictions 
for the same data set.


```r
library("mlr")

task <- makeClassifTask(data = iris, target = "Species")
lrn <- makeLearner("classif.lda")
mod <- train(lrn, task = task)
```

```
## Error: Argument "y" fehlt (ohne Standardwert)
```

```r
predict(mod, newdata = iris)
```

```
## Error: Fehler bei der Auswertung des Argumentes 'object' bei der Methodenauswahl
## für Funktion 'predict': Fehler: Objekt 'mod' nicht gefunden
```



### Regression example

We fit a simple linear regression model to the ``BostonHousing`` data set and predict
on the training data.


```r
library("mlr")
library("mlbench")
data(BostonHousing)

task <- makeRegrTask(data = BostonHousing, target = "medv")
lrn <- makeLearner("regr.lm")
mod <- train(lrn, task)
```

```
## Error: cannot coerce class "c("regr.lm", "RLearnerRegr", "RLearner",
## "Learner")" to a data.frame
```

```r
predict(mod, newdata = BostonHousing)
```

```
## Error: Fehler bei der Auswertung des Argumentes 'object' bei der Methodenauswahl
## für Funktion 'predict': Fehler: Objekt 'mod' nicht gefunden
```



Further information
-------------------

There are several possibilities how to pass the observations for which 
predictions are required.
The first possibility, via the ``newdata``-argument, was already shown in the 
examples above.
If the data for which predictions are required are already contained in 
the [Learner](http://berndbischl.github.io/mlr/makeLearner.html), it is also possible to pass the task and optionally specify 
the subset argument that contains the indices of the test observations.

Predictions are encapsulated in a special [Prediction](http://berndbischl.github.io/mlr/Prediction.html) object. Read the
documentation of the [Prediction](http://berndbischl.github.io/mlr/Prediction.html) class to see all available
accessors.


### Classification example

In case of a classification task, the result of [predict](http://berndbischl.github.io/mlr/predict.WrappedModel.html) depends on 
the predict type, which was set when generating the [Learner](http://berndbischl.github.io/mlr/makeLearner.html). Per default, 
class labels are predicted.

We start again by loading **mlr** and creating a classification task for the 
iris dataset. We select two subsets of the data. We train a decision tree on the
first one and [predict](http://berndbischl.github.io/mlr/predict.WrappedModel.html) the class labels on the test set.


```r
library("mlr")

# At first we define the classification task.
task <- makeClassifTask(data = iris, target = "Species")

# Define the learning algorithm
lrn <- makeLearner("classif.rpart")

# Split the iris data into a training set for learning and a test set.
training.set <- seq(from = 1, to = nrow(iris), by = 2)
test.set <- seq(from = 2, to = nrow(iris), by = 2)

# Now, we can train a decision tree using only the observations in
# ``train.set``:
mod <- train(lrn, task, subset = training.set)
```

```
## Error: cannot coerce class "c("classif.rpart", "RLearnerClassif",
## "RLearner", "Learner")" to a data.frame
```

```r

# Finally, to predict the outcome on new values, we use the predict method:
pred <- predict(mod, newdata = iris[test.set, ])
```

```
## Error: Fehler bei der Auswertung des Argumentes 'object' bei der Methodenauswahl
## für Funktion 'predict': Fehler: Objekt 'mod' nicht gefunden
```


A data frame that contains the true and predicted class labels can be accessed via


```r
head(pred$data)
```

```
## Error: Objekt 'pred' nicht gefunden
```


Alternatively, we can also predict directly from a task:


```r
pred <- predict(mod, task = task, subset = test.set)
```

```
## Error: Fehler bei der Auswertung des Argumentes 'object' bei der Methodenauswahl
## für Funktion 'predict': Fehler: Objekt 'mod' nicht gefunden
```

```r
head(as.data.frame(pred))
```

```
## Error: Fehler bei der Auswertung des Argumentes 'x' bei der Methodenauswahl
## für Funktion 'as.data.frame': Fehler: Objekt 'pred' nicht gefunden
```


When predicting from a task, the resulting data frame contains an additional column, 
called ID, which tells us for which element in the original data set the prediction 
is done. 
(In the iris example the IDs and the rownames coincide.)

In order to get predicted posterior probabilities, we have to change the ``predict.type``
of the learner.


```r
lrn <- makeLearner("classif.rpart", predict.type = "prob")
mod <- train(lrn, task)
```

```
## Error: cannot coerce class "c("classif.rpart", "RLearnerClassif",
## "RLearner", "Learner")" to a data.frame
```

```r
pred <- predict(mod, newdata = iris[test.set, ])
```

```
## Error: Fehler bei der Auswertung des Argumentes 'object' bei der Methodenauswahl
## für Funktion 'predict': Fehler: Objekt 'mod' nicht gefunden
```

```r
head(pred$data)
```

```
## Error: Objekt 'pred' nicht gefunden
```


As you can see, in addition to the predicted probabilities, a response
is produced by choosing the class with the maximum probability and
breaking ties at random.

The predicted posterior probabilities can be accessed via the [getProbabilities](http://berndbischl.github.io/mlr/getProbabilities.html)-function.


```r
head(getProbabilities(pred))
```

```
## Error: Objekt 'pred' nicht gefunden
```



### Binary classification

In case of binary classification, two things are noteworthy. As you might recall, 
we can specify a positive class when generating the task. Moreover, we can set the
threshold value that is used to assign class labels based on the predicted 
posteriors.

To illustrate binary classification we use the Sonar dataset from the
[mlbench](http://cran.r-project.org/web/packages/mlbench/index.html) package. Again, we create a classification task and a learner, which 
predicts probabilities, train the learner and then predict the class labels.



```r
library("mlbench")
data(Sonar)

task <- makeClassifTask(data = Sonar, target = "Class", positive = "M")
lrn <- makeLearner("classif.rpart", predict.type = "prob")
mod <- train(lrn, task = task)
```

```
## Error: Argument "y" fehlt (ohne Standardwert)
```

```r
pred <- predict(mod, task = task)
```

```
## Error: Fehler bei der Auswertung des Argumentes 'object' bei der Methodenauswahl
## für Funktion 'predict': Fehler: Objekt 'mod' nicht gefunden
```

```r
head(pred$data)
```

```
## Error: Objekt 'pred' nicht gefunden
```


In a binary classification setting, we can adjust the threshold, used
to map probabilities, to class labels using [setThreshold](http://berndbischl.github.io/mlr/setThreshold.html). Here, we set
the threshold for the *positive* class to 0.8:


```r
pred <- setThreshold(pred, 0.8)
```

```
## Error: Objekt 'pred' nicht gefunden
```

```r
head(pred$data)
```

```
## Error: Objekt 'pred' nicht gefunden
```

```r
pred$threshold
```

```
## Error: Objekt 'pred' nicht gefunden
```



### Regression example

We again use the BostonHousing data set and learn a Gradient Boosting
Machine. We use every second observation for training/test. The
proceeding is analog to the classification case.


```r
library(mlbench)
data(BostonHousing)

task <- makeRegrTask(data = BostonHousing, target = "medv")

training.set <- seq(from = 1, to = nrow(BostonHousing), by = 2)
test.set <- seq(from = 2, to = nrow(BostonHousing), by = 2)

lrn <- makeLearner("regr.gbm", n.trees = 100)
mod <- train(lrn, task, subset = training.set)
```

```
## Error: cannot coerce class "c("regr.gbm", "RLearnerRegr", "RLearner",
## "Learner")" to a data.frame
```

```r

pred <- predict(mod, newdata = BostonHousing[test.set, ])
```

```
## Error: Fehler bei der Auswertung des Argumentes 'object' bei der Methodenauswahl
## für Funktion 'predict': Fehler: Objekt 'mod' nicht gefunden
```

```r

head(pred$data)
```

```
## Error: Objekt 'pred' nicht gefunden
```

