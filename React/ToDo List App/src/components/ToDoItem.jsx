import React, {useState} from "react";

function ToDoItem(props)
{
    const [isDone, setIsDone] = useState(false);

    function handleClick(event)
    {
        setIsDone(prevValue => !prevValue);
    }
    return (
        <div onClick={handleClick}>
            <li style={{textDecoration:isDone ? "line-through" : "none"}}>{props.text}</li>
        </div>
        
    );
}
export default ToDoItem;