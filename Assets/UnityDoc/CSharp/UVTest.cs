using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class UVTest : MonoBehaviour
{
    public int _RowsAmount = 3;
    public int _ColumnsAmount = 12;
    public int _Speed = 1;
    public Vector2 _UV;
    private Vector2 _uvTmp = new Vector2(-1,-1);
    // Start is called before the first frame update
    void Start()
    {
        Debug.Log(_UV);
    }

    // Update is called once per frame
    void Update()
    {
        float time = Mathf.Floor(Time.time * _Speed);
        float y = Mathf.Floor(time / _RowsAmount);
        float x = time - y * _ColumnsAmount;
        Vector2 uv = _UV + new Vector2(x, -y);
        uv.x /= _RowsAmount;
        uv.y /= _ColumnsAmount;
        if (uv.x != _uvTmp.x && uv.y != _uvTmp.y)
        {
            _uvTmp.x = uv.x;
            Debug.Log(uv);
            Debug.Log(Time.time);

        }


       
    }

    void UVUpdate()
    {
        Vector2 vecColumnsRows = new Vector2(_ColumnsAmount, _RowsAmount);
        float totalCount = _RowsAmount * _ColumnsAmount;
        Vector2 vecRowTotalCount = new Vector2(totalCount, _RowsAmount);
    }
}
