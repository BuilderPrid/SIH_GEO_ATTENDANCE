import sys
import json
import joblib
import os
import pandas as pd  # import pandas
# print("woow")
# Load model
model_path = os.path.join(os.path.dirname(__file__), 'ada_boost_model.pkl')
model = joblib.load(model_path)

# Read input JSON from stdin
data = json.loads(sys.stdin.read())
# print("nonono",data)
# Convert the input dict/list into a pandas DataFrame
# Assuming data is a dict with feature names as keys, values as feature values
df = pd.DataFrame([data['features']])  # list with single dict => single-row DataFramefeatures
# print("yayaya",df.columns)
# Optional: reorder columns to match model training feature order
# feature_order = ['Age', 'Gender', 'Years at Company', ...]
# df = df[feature_order]

# Predict using DataFrame (scikit-learn models accept pandas DataFrames)
prediction = model.predict(df)
json_str = df.to_json(orient='records')
# Return result
# print(json.dumps({"prediction": json_str}))
print(json.dumps({ "prediction": prediction.tolist() }))

