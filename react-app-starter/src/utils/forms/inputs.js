import React from "react";
import styled from "styled-components";

export const Input = ({ errors, label, ...props }) => {
    console.log(errors);
    return (
        <InputContainer hasErrors={errors.length > 0}>
            <label>{label}</label>
            <input {...props} />
            <ErrorList errors={errors} />
        </InputContainer>
    );
};

const InputContainer = styled.div`
    label {
        color: ${props => (props.hasErrors ? "#ff2222" : "#666666")};
    }
    input {
        border-color: ${props => (props.hasErrors ? "#ff2222" : "#666666")};
    }
`;

const ErrorList = ({ errors }) => {
    return errors.length > 0 ? (
        <Ul>
            {errors.map(error => (
                <li>{error}</li>
            ))}
        </Ul>
    ) : null;
};

const Ul = styled.ul`
    padding: 0px;
    li {
      background #ffdddd;
      border 1px solid #ff9999;
      padding: 2px;
      margin-bottom: 2px;
    }
`;
