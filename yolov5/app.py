import torch, base64
from PIL import Image
import json
from io import BytesIO
import pprint

WORK_JPG = '/tmp/in.png'

def handler(event, context):
    model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5s.pt', source="local")    

    data = event.get('body', '')
    data = BytesIO(base64.b64decode(data))
    img = Image.open(data)

    results = model(img)
    data = results.pandas().xyxy[0].to_json(orient="records")

    data = {
        "statusCode": 200,
        "body": data,
    }

    return data

if __name__ == '__main__':
    input_file = './data/images/bus.jpg'
    data = {}
    
    with open(input_file,'rb') as f:
        data["body"]= base64.b64encode(f.read()).decode('utf-8')
    df = handler(data,'context')
    
    pprint.pprint(df)
    exit()