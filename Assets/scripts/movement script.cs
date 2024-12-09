using UnityEngine;

public class SimpleMovement : MonoBehaviour
{
    public float moveSpeed = 5f;  // Speed at which the object moves
    public float jumpForce = 5f;  // Force applied when jumping
    private float jumpCooldown = 1f;  // Time between jumps
    private float lastJumpTime = -1f;  // Track the last time the player jumped

    private Rigidbody rb;

    private void Start()
    {
        rb = GetComponent<Rigidbody>();  // Get the Rigidbody component
    }

    private void Update()
    {
        // Move the object based on player input
        float horizontal = Input.GetAxis("Horizontal");  // A/D or Left/Right arrows
        float vertical = Input.GetAxis("Vertical");  // W/S or Up/Down arrows
        Vector3 movement = new Vector3(horizontal, 0f, vertical) * moveSpeed * Time.deltaTime;
        transform.Translate(movement);

        // Jump when the player presses the space bar and if enough time has passed
        if (Input.GetKeyDown(KeyCode.Space) && Time.time - lastJumpTime >= jumpCooldown)
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);  // Apply jump force
            lastJumpTime = Time.time;  // Update the last jump time
        }
    }
}