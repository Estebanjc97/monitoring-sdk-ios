using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCamera : MonoBehaviour
{
    public float rotationSpeed = 0.5f;

    private Vector2 lastTouchPosition;

    void Update()
    {
        if (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Moved)
        {
            Vector2 touchDeltaPosition = Input.GetTouch(0).deltaPosition;
            transform.Rotate(Vector3.up * -touchDeltaPosition.x * rotationSpeed, Space.World);
        }
    }
}
