% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MultilabelClassifierChainsWrapper.R
\name{makeMultilabelClassifierChainsWrapper}
\alias{makeMultilabelClassifierChainsWrapper}
\title{Use classifier chains method (CC) to create a multilabel learner.}
\usage{
makeMultilabelClassifierChainsWrapper(learner, order = NULL)
}
\arguments{
\item{learner}{[\code{\link{Learner}} | \code{character(1)}]\cr
The learner.
If you pass a string the learner will be created via \code{\link{makeLearner}}.}

\item{order}{[\code{character}]\cr
Specifies the chain order using the names of the target labels.
E.g. for \code{m} target labels, this must be a character vector of length \code{m} that contains a permutation of the target label names.
Default is \code{NULL}, which uses a random ordering of the target label names.}
}
\value{
[\code{\link{Learner}}].
}
\description{
Every learner which is implemented in mlr and which supports binary
classification can be converted to a wrapped classifier chains multilabel learner.
CC trains a binary classifier for each label following a given order. In training phase,
the feature space of each classifier is extended with true label information of all previous
labels in the chain. During the prediction phase, when true labels are not available, they are
replaced by predicted labels.

Models can easily be accessed via \code{\link{getLearnerModel}}.
}
\examples{
d = getTaskData(yeast.task)
# drop some labels so example runs faster
d = d[, c(1:3, 15:117)]
task = makeMultilabelTask(data = d, target = c("label1", "label2", "label3"))
lrn = makeLearner("classif.rpart")
lrn = makeMultilabelBinaryRelevanceWrapper(lrn)
lrn = setPredictType(lrn, "prob")
# train, predict and evaluate
mod = train(lrn, yeast.task)
pred = predict(mod, yeast.task)
performance(pred, measure = list(multilabel.hamloss, multilabel.subset01, multilabel.f1))
getMultilabelBinaryPerformances(pred, measures = list(mmce, auc))
# above works also with predictions from resample!
}
\references{
Montanes, E. et al. (2013)
\emph{Dependent binary relevance models for multi-label classification}
Artificial Intelligence Center, University of Oviedo at Gijon, Spain.
}
\seealso{
Other multilabel: \code{\link{getMultilabelBinaryPerformances}},
  \code{\link{makeMultilabelBinaryRelevanceWrapper}},
  \code{\link{makeMultilabelDBRWrapper}},
  \code{\link{makeMultilabelNestedStackingWrapper}},
  \code{\link{makeMultilabelStackingWrapper}}

Other wrapper: \code{\link{makeBaggingWrapper}},
  \code{\link{makeConstantClassWrapper}},
  \code{\link{makeCostSensClassifWrapper}},
  \code{\link{makeCostSensRegrWrapper}},
  \code{\link{makeDownsampleWrapper}},
  \code{\link{makeFeatSelWrapper}},
  \code{\link{makeFilterWrapper}},
  \code{\link{makeImputeWrapper}},
  \code{\link{makeMulticlassWrapper}},
  \code{\link{makeMultilabelBinaryRelevanceWrapper}},
  \code{\link{makeMultilabelDBRWrapper}},
  \code{\link{makeMultilabelNestedStackingWrapper}},
  \code{\link{makeMultilabelStackingWrapper}},
  \code{\link{makeOverBaggingWrapper}},
  \code{\link{makePreprocWrapperCaret}},
  \code{\link{makePreprocWrapper}},
  \code{\link{makeRemoveConstantFeaturesWrapper}},
  \code{\link{makeSMOTEWrapper}},
  \code{\link{makeTuneWrapper}},
  \code{\link{makeUndersampleWrapper}},
  \code{\link{makeWeightedClassesWrapper}}
}

