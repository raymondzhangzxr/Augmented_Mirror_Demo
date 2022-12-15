// Nov 2022
// Augmented Reality Final Project: Augmented Mirror
// Ray Zhang xzhan227@jh.ede


// Controller for the main camera: 
// Use mouse to change angle of views, use arrow keyboards to change camera position
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraControls : MonoBehaviour {
    
    [Range(0f, 1f)] public float mouse_sensitivity = 0.5f;
    [Range(0f, 20.0f)] public float keyboard_speed = 10.0f;

    private void Start () {
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void Update () {
        if (Cursor.lockState == CursorLockMode.Locked) {
            float rotX = transform.eulerAngles.y;
            float rotY = transform.eulerAngles.x;
            if (rotY > 180) {
                rotY -= 360;
            }
            rotX += Input.GetAxis("Mouse X") * (1f + mouse_sensitivity * 9f);
            rotY -= Input.GetAxis("Mouse Y") * (1f + mouse_sensitivity * 9f);
            rotY = Mathf.Clamp(rotY, -80f, 80f);
            transform.eulerAngles = new Vector3(rotY, rotX, 0f);
        }
        
        if (Input.GetMouseButtonDown(0)) {
            CatchOrReleaseMouse();
        }

        if (Input.GetKeyDown(KeyCode.Escape)) {
            Screen.fullScreen = !Screen.fullScreen;
        }

        if (Input.GetKey(KeyCode.RightArrow))
        {
            transform.Translate(new Vector3(keyboard_speed * Time.deltaTime, 0, 0));
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            transform.Translate(new Vector3(-keyboard_speed * Time.deltaTime, 0, 0));
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            transform.Translate(new Vector3(0, -keyboard_speed * Time.deltaTime, 0));
        }
        if (Input.GetKey(KeyCode.UpArrow))
        {
            transform.Translate(new Vector3(0, keyboard_speed * Time.deltaTime, 0));
        }
    }

    private void CatchOrReleaseMouse () {
        if (Cursor.lockState == CursorLockMode.Locked) {
            Cursor.lockState = CursorLockMode.None;
        }
        else {
            Cursor.lockState = CursorLockMode.Locked;
        }
    }
}
