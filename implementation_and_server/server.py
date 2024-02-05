from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.staticfiles import StaticFiles

from fastapi.responses import JSONResponse
import os
import numpy as np
import cv2
import os
from collections import Counter
import face_recognition
def detected_faces(image_path):
    # Load the image
    image = face_recognition.load_image_file(image_path)
    # Find all faces in the image
    face_locations = face_recognition.face_locations(image)
    # Return True if at least one face is detected, False otherwise
    return len(face_locations) 
def preprocess_images(source_dir, dest_dir):
    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)
    for root, dirs, files in os.walk(source_dir):
        for name in files:
            if name.lower().endswith(('jpg', 'jpeg')):
                file_path = os.path.join(root, name)
                image = cv2.imread(file_path)
                image = cv2.resize(image, (500, 500))
                gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
                dest_folder = os.path.join(dest_dir, os.path.relpath(root, source_dir))
                if not os.path.exists(dest_folder):
                    os.makedirs(dest_folder)
                cv2.imwrite(os.path.join(dest_folder, name), gray_image)

def load_and_flatten_images(folder):
    images, labels, label_map = [], [], {}
    label_counter = 0
    for root, dirs, files in os.walk(folder):
        for file in files:
            if file.lower().endswith(('jpg', 'jpeg')):
                path = os.path.join(root, file)
                img = cv2.imread(path, cv2.IMREAD_GRAYSCALE)
                images.append(img.flatten())
                label = os.path.basename(root)
                if label not in label_map:
                    label_map[label] = label_counter
                    label_counter += 1
                labels.append(label_map[label])
    return np.array(images), np.array(labels), label_map

def pca(X, num_components=100):
    mean_face = np.mean(X, axis=0)
    X_centered = X - mean_face
    U, S, Vt = np.linalg.svd(X_centered, full_matrices=False)
    eigenfaces = Vt[:num_components]
    return mean_face, eigenfaces

def project_faces(X, mean_face, eigenfaces):
    X_centered = X - mean_face
    return np.dot(X_centered, eigenfaces.T)

def k_nearest_neighbors(training_data, training_labels, test_data, k=5):
    distances = np.sqrt(((training_data - test_data) ** 2).sum(axis=1))
    nearest_indices = np.argsort(distances)[:k]
    return Counter(training_labels[nearest_indices]).most_common(1)[0][0]

def evaluate_model(train_projections, train_labels, test_projections, test_labels):
    correct_predictions = 0
    for i, test_projection in enumerate(test_projections):
        predicted_label = k_nearest_neighbors(train_projections, train_labels, test_projection)
        if predicted_label == test_labels[i]:
            correct_predictions += 1
    accuracy = correct_predictions / len(test_projections)
    return accuracy

def predict_person(image_path, mean_face, eigenfaces, label_map, train_projections, train_labels):
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    img_resized = cv2.resize(img, (500, 500)).flatten()
    projected_face = project_faces(np.array([img_resized]), mean_face, eigenfaces)
    predicted_label = k_nearest_neighbors(train_projections, train_labels, projected_face)
    predicted_person = [person for person, label in label_map.items() if label == predicted_label][0]
    return predicted_person


script_directory = os.path.dirname(__file__)
source_dir = os.path.join(script_directory, '../photos')
dest_dir = os.path.join(script_directory, '../preprocessed_photos')
preprocess_images(source_dir, dest_dir)



images, labels, label_map = load_and_flatten_images(dest_dir)
train_split =  len(images)
train_images, train_labels = images[:train_split], labels[:train_split]
# test_images, test_labels = images[train_split:], labels[train_split:]

mean_face, eigenfaces = pca(train_images, 150)
projected_train_faces = project_faces(train_images, mean_face, eigenfaces)

current_file_dir = os.path.dirname(__file__)
project_root = os.path.dirname(current_file_dir)  # Move one directory up to the project root
photos_dir = os.path.join(project_root, 'photos')  # Path to the 'photos' directory






project_root = os.path.dirname(script_directory)  # Assuming 'script_directory' is inside 'codes'
photos_dir = os.path.join(project_root, 'photos')

app = FastAPI()

app.mount("/photos", StaticFiles(directory=photos_dir), name="photos")





@app.post("/uploadimage/")
async def create_upload_file(file: UploadFile = File(..., alias="picture")):  # Adding alias parameter

    print("incoming request ... ")
    try:
        # Save the uploaded file temporarily
        temp_file_path = os.path.join(script_directory, "temp_image.jpg")  # Consider using a unique name or a temporary file
        with open(temp_file_path, "wb+") as file_object:
            file_object.write(await file.read())
        test_image_path = os.path.join(script_directory , temp_file_path)  # Update this path
        predicted_person = predict_person(test_image_path, mean_face, eigenfaces, label_map, projected_train_faces, train_labels)
        print("predicted as" ,   predict_person)
        detected_faces_num = detected_faces(test_image_path)
        print("detected_faces",detected_faces_num)
        if(detected_faces_num == 0):
            return JSONResponse(content= {"predicted_person": "No face detected"}, status_code=400)
          
        elif(detected_faces_num > 1):
            return JSONResponse(content= {"predicted_person": "Multiple faces detected"}, status_code=400)
        person_images_dir = os.path.join(source_dir, predicted_person)
        image_urls = [f"/photos/{predicted_person}/{filename}" for filename in os.listdir(person_images_dir)]
        return JSONResponse(content={"predicted_person": predicted_person, "image_urls": image_urls}, status_code=200)
        
        # return {"predicted_person": predicted_person} , 200
    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
