from sklearn.preprocessing import StandardScaler, LabelEncoder
from xgboost import XGBClassifier
import pandas as pd
import joblib

label_encoder = LabelEncoder()

dataframe = pd.read_csv('./datasets/Dataset_WOD.csv')

dataframe.dropna(inplace=True)
dataframe.rename(columns=lambda x : x.lower(), inplace=True)

dataframe['label'] = label_encoder.fit_transform(dataframe['label'])
x = dataframe.drop(columns=['id', 'label'], axis=1)
y = dataframe['label']
scaler = StandardScaler().fit(x)
x = pd.DataFrame(scaler.transform(x))
xgboost_model = XGBClassifier(objective="binary:logistic", n_estimators=20, random_state=42, eval_metric=["auc", "error", "error@0.6"])
xgboost_model.fit(x, y)

joblib.dump(xgboost_model, './models/WOD/xgboost_model.joblib')
joblib.dump(scaler, './models/WOD/scaler.joblib')

print("Model WOD has been trained and exported")
